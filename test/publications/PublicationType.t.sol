// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import 'test/mocks/MockModule.sol';
import 'test/base/BaseTest.t.sol';

contract PublicationTypeTest is BaseTest {
    TestAccount publisher;

    function setUp() public virtual override {
        super.setUp();
        publisher = _loadAccountAs('PUBLISHER');
    }

    function testGetPublicationType_Post() public {
        Types.PostParams memory postParams = _getDefaultPostParams();
        postParams.profileId = publisher.profileId;
        vm.prank(publisher.owner);
        uint256 pubId = hub.post(postParams);

        assertTrue(hub.getPublicationType(publisher.profileId, pubId) == Types.PublicationType.Post);
    }

    function testGetPublicationType_Comment() public {
        Types.CommentParams memory commentParams = _getDefaultCommentParams();
        commentParams.profileId = publisher.profileId;
        vm.prank(publisher.owner);
        uint256 pubId = hub.comment(commentParams);

        assertTrue(hub.getPublicationType(publisher.profileId, pubId) == Types.PublicationType.Comment);
    }

    function testGetPublicationType_Mirror() public {
        Types.MirrorParams memory mirrorParams = _getDefaultMirrorParams();
        mirrorParams.profileId = publisher.profileId;
        vm.prank(publisher.owner);
        uint256 pubId = hub.mirror(mirrorParams);

        assertTrue(hub.getPublicationType(publisher.profileId, pubId) == Types.PublicationType.Mirror);
    }

    function testGetPublicationType_quote() public {
        Types.QuoteParams memory quoteParams = _getDefaultQuoteParams();
        quoteParams.profileId = publisher.profileId;
        vm.prank(publisher.owner);
        uint256 pubId = hub.quote(quoteParams);

        assertTrue(hub.getPublicationType(publisher.profileId, pubId) == Types.PublicationType.Quote);
    }

}
