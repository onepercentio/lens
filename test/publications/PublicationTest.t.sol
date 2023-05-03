// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import 'test/mocks/MockModule.sol';
import 'test/base/BaseTest.t.sol';

/**
 * Tests shared among all type of publications. Posts, Comments, Quotes, and Mirrors.
 */
abstract contract PublicationTest is BaseTest {
    TestAccount publisher;
    TestAccount anotherPublisher;

    function _publish(uint256 signerPk, uint256 publisherProfileId) internal virtual returns (uint256);

    function _pubType() internal virtual returns (Types.PublicationType);

    function setUp() public virtual override {
        super.setUp();
        publisher = _loadAccountAs('PUBLISHER');
        anotherPublisher = _loadAccountAs('ANOTHER_PUBLISHER');
    }

    // Negatives

    function testCannotPublish_IfProtocolStateIs_Paused() public {
        vm.prank(governance);
        hub.setState(Types.ProtocolState.Paused);

        vm.expectRevert(Errors.PublishingPaused.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testCannotPublish_IfProtocolStateIs_PublishingPaused() public {
        vm.prank(governance);
        hub.setState(Types.ProtocolState.PublishingPaused);

        vm.expectRevert(Errors.PublishingPaused.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testCannotPublish_IfExecutorIsNot_PublisherProfileOwnerOrDelegatedExecutor(
        uint256 nonOwnerNorDelegatedExecutorPk
    ) public {
        nonOwnerNorDelegatedExecutorPk = _boundPk(nonOwnerNorDelegatedExecutorPk);
        vm.assume(nonOwnerNorDelegatedExecutorPk != publisher.ownerPk);
        address nonOwnerNorDelegatedExecutor = vm.addr(nonOwnerNorDelegatedExecutorPk);
        vm.assume(!hub.isDelegatedExecutorApproved(publisher.profileId, nonOwnerNorDelegatedExecutor));

        vm.expectRevert(Errors.ExecutorInvalid.selector);
        _publish({signerPk: nonOwnerNorDelegatedExecutorPk, publisherProfileId: publisher.profileId});
    }

    // Scenarios

    function testPublisherPubCountIs_IncrementedByOne_AfterPublishing() public {
        uint256 pubCountBeforePublishing = hub.getPubCount(publisher.profileId);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
        uint256 pubCountAfterPublishing = hub.getPubCount(publisher.profileId);
        assertEq(pubCountAfterPublishing, pubCountBeforePublishing + 1);
    }

    function testPubIdAssignedIs_EqualsToPubCount_AfterPublishing() public {
        uint256 pubIdAssigned = _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
        uint256 pubCountAfterPublishing = hub.getPubCount(publisher.profileId);
        assertEq(pubIdAssigned, pubCountAfterPublishing);
    }

    function testCanPublishIf_ExecutorIs_PublisherProfileApprovedDelegatedExecutor(uint256 delegatedExecutorPk) public {
        delegatedExecutorPk = _boundPk(delegatedExecutorPk);
        vm.assume(delegatedExecutorPk != publisher.ownerPk);
        address delegatedExecutor = vm.addr(delegatedExecutorPk);
        vm.prank(publisher.owner);
        hub.changeDelegatedExecutorsConfig({
            delegatorProfileId: publisher.profileId,
            delegatedExecutors: _toAddressArray(delegatedExecutor),
            approvals: _toBoolArray(true)
        });

        _publish({signerPk: delegatedExecutorPk, publisherProfileId: publisher.profileId});
    }

    function testCanPublishIf_ExecutorIs_PublisherProfileOwner() public {
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testPublicationTypeIsCorrect() public {
        uint256 publicationIdAssigned = _publish({
            signerPk: publisher.ownerPk,
            publisherProfileId: publisher.profileId
        });
        Types.PublicationType assignedPubType = hub.getPublicationType(publisher.profileId, publicationIdAssigned);
        Types.PublicationType expectedPubType = _pubType();
        assertTrue(assignedPubType == expectedPubType, 'Assigned publication type is different than the expected one');
    }
}

/**
 * Tests for publications that can handle actions. Posts, Comments, and Quotes, but not Mirrors.
 */
abstract contract ActionablePublicationTest is PublicationTest {
    function _setActionModules(address[] memory actionModules, bytes[] memory actionModulesInitDatas) internal virtual;
}

/**
 * Tests for publications that points to another publication. Comments, Quotes, and Mirrors, but not Posts.
 */
abstract contract ReferencePublicationTest is PublicationTest {
    function _setReferrers(uint256[] memory referrerProfileIds, uint256[] memory referrerPubIds) internal virtual;

    function _setReferenceModuleData(bytes memory referenceModuleData) internal virtual;

    function _setPointedPub(uint256 pointedProfileId, uint256 pointedPubId) internal virtual;

    function testCannotReferenceA_Post_IfReferenceModule_RejectsIt() public {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.profileId = anotherPublisher.profileId;
        postParams.referenceModule = address(mockReferenceModule);
        postParams.referenceModuleInitData = abi.encode(true);
        vm.prank(anotherPublisher.owner);
        uint256 pointedPubId = hub.post(postParams);

        _setPointedPub(anotherPublisher.profileId, pointedPubId);
        _setReferenceModuleData(abi.encode(false));

        vm.expectRevert(MockModule.MockModuleReverted.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testCannotReferenceA_Comment_IfReferenceModule_RejectsIt() public {
        Types.CommentParams memory commentParams = _getDefaultCommentParams();
        commentParams.profileId = anotherPublisher.profileId;
        commentParams.referenceModule = address(mockReferenceModule);
        commentParams.referenceModuleInitData = abi.encode(true);
        vm.prank(anotherPublisher.owner);
        uint256 pointedPubId = hub.comment(commentParams);

        _setPointedPub(anotherPublisher.profileId, pointedPubId);
        _setReferenceModuleData(abi.encode(false));

        vm.expectRevert(MockModule.MockModuleReverted.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testCannotReferenceA_Quote_IfReferenceModule_RejectsIt() public {
        Types.QuoteParams memory quoteParams = _getDefaultQuoteParams();
        quoteParams.profileId = anotherPublisher.profileId;
        quoteParams.referenceModule = address(mockReferenceModule);
        quoteParams.referenceModuleInitData = abi.encode(true);
        vm.prank(anotherPublisher.owner);
        uint256 pointedPubId = hub.quote(quoteParams);

        _setPointedPub(anotherPublisher.profileId, pointedPubId);
        _setReferenceModuleData(abi.encode(false));

        vm.expectRevert(MockModule.MockModuleReverted.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testCannotReferenceA_Mirror() public {
        Types.MirrorParams memory mirrorParams = _getDefaultMirrorParams();
        mirrorParams.profileId = anotherPublisher.profileId;
        vm.prank(anotherPublisher.owner);
        uint256 pointedPubId = hub.mirror(mirrorParams);

        _setPointedPub(anotherPublisher.profileId, pointedPubId);

        vm.expectRevert(Errors.InvalidPointedPub.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testCannotReferenceA_PublicationFromA_ProfileThatDoesNotExist(uint256 nonExistentProfileId) public {
        vm.assume(!hub.exists(nonExistentProfileId));

        _setPointedPub(nonExistentProfileId, 1);

        vm.expectRevert(Errors.InvalidPointedPub.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testCannotReferenceAn_NonExistentPublication_FromAnExistentProfile(uint256 nonExistentPubId) public {
        assertTrue(hub.exists(anotherPublisher.profileId));
        vm.assume(
            hub.getPublicationType(anotherPublisher.profileId, nonExistentPubId) == Types.PublicationType.Nonexistent
        );

        _setPointedPub(anotherPublisher.profileId, nonExistentPubId);

        vm.expectRevert(Errors.InvalidPointedPub.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }

    function testCannotReference_Itself() public {
        uint256 nextPubId = hub.getPubCount(publisher.profileId) + 1;

        _setPointedPub(publisher.profileId, nextPubId);

        vm.expectRevert(Errors.InvalidPointedPub.selector);
        _publish({signerPk: publisher.ownerPk, publisherProfileId: publisher.profileId});
    }
}