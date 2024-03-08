// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import 'test/base/BaseTest.t.sol';

/*
This kind of tree is created:

    Post_1
    |
    |-- Comment/Quote_0 -- Mirror_0 (mirror of a direct reference)
    |        |
    |        |-- Comment/Quote_1 -- Mirror_1 (mirror of a 1st level reference)
    |                 |
    |                 |-- Comment/Quote_2 -- Mirror_2 (mirror of a 2nd level reference)
    |                           |
    |                           |-- Comment/Quote_3 -- Mirror_3 (mirror of a 3rd level reference)
    |
    |
    |-- Comment/Quote_4 -- Mirror_4 (a different branch)
    |
    |
    |-- Mirror_5 (direct post mirror)
*/

/**
 * Tests shared among all operations where the Lens V2 Referral System applies, e.g. act, quote, comment, mirror.
 */
abstract contract ReferralSystemTest is BaseTest {
    uint256 testAccountId;

    function _referralSystem_PrepareOperation(
        TestPublication memory target,
        uint256[] memory referrerProfileIds,
        uint256[] memory referrerPubIds
    ) internal virtual;

    // Returns true if expectRevert was added, so we avoid a dobule expectRevert scenario.
    function _referralSystem_ExpectRevertsIfNeeded(
        TestPublication memory target,
        uint256[] memory referrerProfileIds,
        uint256[] memory referrerPubIds
    ) internal virtual returns (bool);

    function _referralSystem_ExecutePreparedOperation() internal virtual;

    /////////////////////////////////
    // Internal helpers
    /////////////////////////////////

    function _referralSystem_PrepareOperation(
        TestPublication memory target,
        TestPublication memory referralPub
    ) private {
        _referralSystem_PrepareOperation(
            target,
            _toUint256Array(referralPub.profileId),
            _toUint256Array(referralPub.pubId)
        );
    }

    // Returns true if expectRevert was added, so we avoid a dobule expectRevert scenario.
    function _referralSystem_ExpectRevertsIfNeeded(
        TestPublication memory target,
        TestPublication memory referralPub
    ) private returns (bool) {
        return
            _referralSystem_ExpectRevertsIfNeeded(
                target,
                _toUint256Array(referralPub.profileId),
                _toUint256Array(referralPub.pubId)
            );
    }

    function _executeOperation(TestPublication memory target, TestPublication memory referralPub) private {
        _referralSystem_PrepareOperation(target, referralPub);
        _referralSystem_ExpectRevertsIfNeeded(target, referralPub);
        _referralSystem_ExecutePreparedOperation();
    }

    /////////////////////////////////

    // TODO: Move this to TestSetup? And get rid of this setUp
    function setUp() public virtual override {
        super.setUp();
    }

    struct Tree {
        TestPublication post;
        TestPublication[] references;
        TestPublication[] mirrors;
    }

    function testV2UnverifiedReferrals() public virtual {
        TestAccount memory profileReferral = _loadAccountAs('PROFILE_REFERRAL');
        TestPublication memory referralPub = TestPublication(profileReferral.profileId, 0);

        for (uint256 commentQuoteFuzzBitmap = 0; commentQuoteFuzzBitmap < 32; commentQuoteFuzzBitmap++) {
            Tree memory treeV2 = _createV2Tree(commentQuoteFuzzBitmap);

            {
                TestPublication memory target = treeV2.post;
                _executeOperation(target, referralPub);
            }

            {
                for (uint256 i = 0; i < treeV2.references.length; i++) {
                    TestPublication memory target = treeV2.references[i];
                    _executeOperation(target, referralPub);
                }
            }
        }
    }

    function testCannot_PassV2UnverifiedReferral_SameAsTargetAuthor() public virtual {
        for (uint256 commentQuoteFuzzBitmap = 0; commentQuoteFuzzBitmap < 32; commentQuoteFuzzBitmap++) {
            Tree memory treeV2 = _createV2Tree(commentQuoteFuzzBitmap);

            {
                TestPublication memory target = treeV2.post;
                TestPublication memory referralPub = TestPublication(target.profileId, 0);
                _referralSystem_PrepareOperation(target, referralPub);

                if (!_referralSystem_ExpectRevertsIfNeeded(target, referralPub)) {
                    vm.expectRevert(Errors.InvalidReferrer.selector);
                }

                _referralSystem_ExecutePreparedOperation();
            }

            {
                for (uint256 i = 0; i < treeV2.references.length; i++) {
                    TestPublication memory target = treeV2.references[i];
                    TestPublication memory referralPub = TestPublication(target.profileId, 0);
                    _referralSystem_PrepareOperation(target, referralPub);

                    if (!_referralSystem_ExpectRevertsIfNeeded(target, referralPub)) {
                        vm.expectRevert(Errors.InvalidReferrer.selector);
                    }

                    _referralSystem_ExecutePreparedOperation();
                }
            }
        }
    }

    function testV2Referrals() public virtual {
        for (uint256 commentQuoteFuzzBitmap = 0; commentQuoteFuzzBitmap < 32; commentQuoteFuzzBitmap++) {
            Tree memory treeV2 = _createV2Tree(commentQuoteFuzzBitmap);

            console.log('Created a tree. Executing operations...');
            {
                // Target a post with quote/comment as referrals
                console.log('Target a post with quote/comment as referrals');
                TestPublication memory target = treeV2.post;
                for (uint256 i = 0; i < treeV2.references.length; i++) {
                    TestPublication memory referralPub = treeV2.references[i];
                    _executeOperation(target, referralPub);
                }
            }

            {
                // Target a post with mirrors as referrals
                console.log('Target a post with mirrors as referrals');
                TestPublication memory target = treeV2.post;
                for (uint256 i = 0; i < treeV2.mirrors.length; i++) {
                    TestPublication memory referralPub = treeV2.mirrors[i];
                    _executeOperation(target, referralPub);
                }
            }

            {
                // Target as a quote/comment node and pass another quote/comments as referral
                console.log('Target as a quote/comment node and pass another quote/comments as referral');
                for (uint256 i = 0; i < treeV2.references.length; i++) {
                    TestPublication memory target = treeV2.references[i];
                    for (uint256 j = 0; j < treeV2.references.length; j++) {
                        TestPublication memory quoteOrCommentAsReferralPub = treeV2.references[j];
                        if (i == j) continue; // skip self
                        // vm.expectCall /* */();

                        console.log('Target Quote/Comment: %s %s', target.profileId, target.pubId);
                        console.log(
                            'Referral Quote/Comment: %s %s',
                            quoteOrCommentAsReferralPub.profileId,
                            quoteOrCommentAsReferralPub.pubId
                        );
                        _executeOperation(target, quoteOrCommentAsReferralPub);
                    }

                    // One special case is a post as referal for reference node
                    console.log('Special case: Target as a quote/comment node and pass post as referral');
                    TestPublication memory referralPub = treeV2.post;
                    // vm.expectCall /* */();
                    _executeOperation(target, referralPub);
                }
            }

            {
                // Target as a quote/comment node and pass mirror as referral
                console.log('Target as a quote/comment node and pass mirror as referral');
                for (uint256 i = 0; i < treeV2.references.length; i++) {
                    TestPublication memory target = treeV2.references[i];
                    for (uint256 j = 0; j < treeV2.mirrors.length; j++) {
                        TestPublication memory referralPub = treeV2.mirrors[j];
                        if (i == j) continue; // skip self
                        // vm.expectCall /* */();

                        _executeOperation(target, referralPub);
                    }
                }
            }
        }
    }


    function _createV2Tree(uint256 commentQuoteFuzzBitmap) internal returns (Tree memory) {
        Tree memory tree;
        tree.references = new TestPublication[](5);
        tree.mirrors = new TestPublication[](6);

        tree.post = _post();

        tree.references[0] = _commentOrQuote(tree.post, commentQuoteFuzzBitmap, 0);
        tree.mirrors[0] = _mirror(tree.references[0]);
        tree.references[1] = _commentOrQuote(tree.references[0], commentQuoteFuzzBitmap, 1);
        tree.mirrors[1] = _mirror(tree.references[1]);
        tree.references[2] = _commentOrQuote(tree.references[1], commentQuoteFuzzBitmap, 2);
        tree.mirrors[2] = _mirror(tree.references[2]);
        tree.references[3] = _commentOrQuote(tree.references[2], commentQuoteFuzzBitmap, 3);
        tree.mirrors[3] = _mirror(tree.references[3]);

        tree.references[4] = _commentOrQuote(tree.post, commentQuoteFuzzBitmap, 4);
        tree.mirrors[4] = _mirror(tree.references[4]);

        tree.mirrors[5] = _mirror(tree.post);

        return tree;
    }


    function _commentOrQuote(
        TestPublication memory testPub,
        uint256 commentQuoteFuzzBitmap,
        uint256 commentQuoteIndex
    ) internal returns (TestPublication memory) {
        uint256 commentQuoteFuzz = (commentQuoteFuzzBitmap >> (commentQuoteIndex)) & 1;
        if (commentQuoteFuzz == 0) {
            return _comment(testPub);
        } else {
            return _quote(testPub);
        }
    }

    function _post() internal returns (TestPublication memory) {
        testAccountId++;
        TestAccount memory publisher = _loadAccountAs(string.concat('TESTACCOUNT_', vm.toString(testAccountId)));
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.profileId = publisher.profileId;

        if (testAccountId % 2 == 0) {
            postParams.referenceModule = address(mockReferenceModule);
            postParams.referenceModuleInitData = abi.encode(true);
        }

        vm.prank(publisher.owner);
        uint256 pubId = hub.post(postParams);

        console.log('Created POST: %s, %s', publisher.profileId, pubId);
        return TestPublication(publisher.profileId, pubId);
    }

    function _mirror(TestPublication memory testPub) internal returns (TestPublication memory) {
        testAccountId++;
        TestAccount memory publisher = _loadAccountAs(string.concat('TESTACCOUNT_', vm.toString(testAccountId)));
        Types.MirrorParams memory mirrorParams = _getDefaultMirrorParams();
        mirrorParams.profileId = publisher.profileId;
        mirrorParams.pointedPubId = testPub.pubId;
        mirrorParams.pointedProfileId = testPub.profileId;
        mirrorParams.referenceModuleData = abi.encode(true);

        vm.prank(publisher.owner);
        uint256 pubId = hub.mirror(mirrorParams);

        console.log(
            'Created MIRROR: (%s) => (%s)',
            string.concat(vm.toString(publisher.profileId), ', ', vm.toString(pubId)),
            string.concat(vm.toString(testPub.profileId), ', ', vm.toString(testPub.pubId))
        );

        return TestPublication(publisher.profileId, pubId);
    }

    function _comment(TestPublication memory testPub) internal returns (TestPublication memory) {
        testAccountId++;
        TestAccount memory publisher = _loadAccountAs(string.concat('TESTACCOUNT_', vm.toString(testAccountId)));
        Types.CommentParams memory commentParams = _getDefaultCommentParams();

        commentParams.profileId = publisher.profileId;
        commentParams.pointedPubId = testPub.pubId;
        commentParams.pointedProfileId = testPub.profileId;
        commentParams.referenceModuleData = abi.encode(true);

        if (testAccountId % 2 == 0) {
            commentParams.referenceModule = address(mockReferenceModule);
            commentParams.referenceModuleInitData = abi.encode(true);
        }

        vm.prank(publisher.owner);
        uint256 pubId = hub.comment(commentParams);

        console.log(
            'Created COMMENT: (%s) => (%s)',
            string.concat(vm.toString(publisher.profileId), ', ', vm.toString(pubId)),
            string.concat(vm.toString(testPub.profileId), ', ', vm.toString(testPub.pubId))
        );

        return TestPublication(publisher.profileId, pubId);
    }

    function _quote(TestPublication memory testPub) internal returns (TestPublication memory) {
        testAccountId++;
        TestAccount memory publisher = _loadAccountAs(string.concat('TESTACCOUNT_', vm.toString(testAccountId)));
        Types.QuoteParams memory quoteParams = _getDefaultQuoteParams();

        quoteParams.profileId = publisher.profileId;
        quoteParams.pointedPubId = testPub.pubId;
        quoteParams.pointedProfileId = testPub.profileId;
        quoteParams.referenceModuleData = abi.encode(true);

        if (testAccountId % 2 == 0) {
            quoteParams.referenceModule = address(mockReferenceModule);
            quoteParams.referenceModuleInitData = abi.encode(true);
        }

        vm.prank(publisher.owner);
        uint256 pubId = hub.quote(quoteParams);

        console.log(
            'Created QUOTE: (%s) => (%s)',
            string.concat(vm.toString(publisher.profileId), ', ', vm.toString(pubId)),
            string.concat(vm.toString(testPub.profileId), ', ', vm.toString(testPub.pubId))
        );

        return TestPublication(publisher.profileId, pubId);
    }

    function testCannotExecuteOperationIf_ReferralProfileIdsPassedQty_DiffersFromPubIdsQty() public virtual {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.referenceModule = address(mockReferenceModule);
        postParams.referenceModuleInitData = abi.encode(true);
        vm.prank(defaultAccount.owner);
        TestPublication memory targetPub = TestPublication(defaultAccount.profileId, hub.post(postParams));

        TestPublication memory referralPub = _comment(targetPub);

        _referralSystem_PrepareOperation(targetPub, _toUint256Array(referralPub.profileId), _emptyUint256Array());
        vm.expectRevert(Errors.ArrayMismatch.selector);
        _referralSystem_ExecutePreparedOperation();

        _referralSystem_PrepareOperation(targetPub, _emptyUint256Array(), _toUint256Array(referralPub.pubId));
        vm.expectRevert(Errors.ArrayMismatch.selector);
        _referralSystem_ExecutePreparedOperation();
    }

    function testCannotPass_TargetedPublication_AsReferrer() public virtual {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.referenceModule = address(mockReferenceModule);
        postParams.referenceModuleInitData = abi.encode(true);
        vm.prank(defaultAccount.owner);
        TestPublication memory targetPub = TestPublication(defaultAccount.profileId, hub.post(postParams));

        _referralSystem_PrepareOperation(targetPub, targetPub);
        vm.expectRevert(Errors.InvalidReferrer.selector);
        _referralSystem_ExecutePreparedOperation();
    }

    function testCannotPass_UnexistentProfile_AsReferrer(uint256 unexistentProfileId, uint8 pubId) public virtual {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.referenceModule = address(mockReferenceModule);
        postParams.referenceModuleInitData = abi.encode(true);
        vm.prank(defaultAccount.owner);
        TestPublication memory targetPub = TestPublication(defaultAccount.profileId, hub.post(postParams));

        vm.assume(!hub.exists(unexistentProfileId));
        vm.assume(pubId != 0);
        _referralSystem_PrepareOperation(targetPub, _toUint256Array(unexistentProfileId), _toUint256Array(pubId));
        vm.expectRevert(Errors.InvalidReferrer.selector);
        _referralSystem_ExecutePreparedOperation();
    }

    function testCannotPass_UnexistentPublication_AsReferrer(uint256 unexistentPubId) public virtual {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.referenceModule = address(mockReferenceModule);
        postParams.referenceModuleInitData = abi.encode(true);
        vm.prank(defaultAccount.owner);
        TestPublication memory targetPub = TestPublication(defaultAccount.profileId, hub.post(postParams));

        TestPublication memory pub = _comment(targetPub);
        uint256 existentProfileId = pub.profileId;
        vm.assume(unexistentPubId > pub.pubId);

        _referralSystem_PrepareOperation(
            targetPub,
            _toUint256Array(existentProfileId),
            _toUint256Array(unexistentPubId)
        );
        vm.expectRevert(Errors.InvalidReferrer.selector);
        _referralSystem_ExecutePreparedOperation();
    }

    function testCannotPass_UnexistentProfile_AsUnverifiedReferrer(uint256 unexistentProfileId) public virtual {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.referenceModule = address(mockReferenceModule);
        postParams.referenceModuleInitData = abi.encode(true);
        vm.prank(defaultAccount.owner);
        TestPublication memory targetPub = TestPublication(defaultAccount.profileId, hub.post(postParams));

        vm.assume(!hub.exists(unexistentProfileId));
        _referralSystem_PrepareOperation(targetPub, _toUint256Array(unexistentProfileId), _toUint256Array(0));
        vm.expectRevert(Errors.InvalidReferrer.selector);
        _referralSystem_ExecutePreparedOperation();
    }

    function testCannotPass_BurntProfile_AsUnverifiedReferrer() public virtual {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.referenceModule = address(mockReferenceModule);
        postParams.referenceModuleInitData = abi.encode(true);
        vm.prank(defaultAccount.owner);
        TestPublication memory targetPub = TestPublication(defaultAccount.profileId, hub.post(postParams));

        TestPublication memory referralPub = _comment(targetPub);
        address referralOwner = hub.ownerOf(referralPub.profileId);

        _effectivelyDisableProfileGuardian(referralOwner);

        vm.prank(referralOwner);
        hub.burn(referralPub.profileId);

        _referralSystem_PrepareOperation(targetPub, _toUint256Array(referralPub.profileId), _toUint256Array(0));
        vm.expectRevert(Errors.InvalidReferrer.selector);
        _referralSystem_ExecutePreparedOperation();
    }

    // This test might fail at some point when we check for duplicates!
    function testPassingDuplicatedReferralsIsAllowed() public {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.referenceModule = address(mockReferenceModule);
        postParams.referenceModuleInitData = abi.encode(true);
        vm.prank(defaultAccount.owner);
        TestPublication memory targetPub = TestPublication(defaultAccount.profileId, hub.post(postParams));

        TestPublication memory referralPub = _comment(targetPub);
        _referralSystem_PrepareOperation(
            targetPub,
            _toUint256Array(referralPub.profileId, referralPub.profileId),
            _toUint256Array(referralPub.pubId, referralPub.pubId)
        );
        _referralSystem_ExecutePreparedOperation();
    }
}
