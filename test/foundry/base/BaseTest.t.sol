// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import 'test/foundry/base/TestSetup.t.sol';
import 'contracts/libraries/constants/Types.sol';
import {Typehash} from 'contracts/libraries/constants/Typehash.sol';

contract BaseTest is TestSetup {
    function _getSetProfileMetadataURITypedDataHash(
        uint256 profileId,
        string memory metadataURI,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(Typehash.SET_PROFILE_METADATA_URI, profileId, keccak256(bytes(metadataURI)), nonce, deadline)
        );
        return _calculateDigest(structHash);
    }

    function _getSetFollowModuleTypedDataHash(
        uint256 profileId,
        address followModule,
        bytes memory followModuleInitData,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(
                Typehash.SET_FOLLOW_MODULE,
                profileId,
                followModule,
                keccak256(followModuleInitData),
                nonce,
                deadline
            )
        );
        return _calculateDigest(structHash);
    }

    function _getChangeDelegatedExecutorsConfigTypedDataHash(
        uint256 delegatorProfileId,
        uint64 configNumber,
        address[] memory executors,
        bool[] memory approvals,
        bool switchToGivenConfig,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(
                Typehash.CHANGE_DELEGATED_EXECUTORS_CONFIG,
                delegatorProfileId,
                abi.encodePacked(executors),
                abi.encodePacked(approvals),
                configNumber,
                switchToGivenConfig,
                nonce,
                deadline
            )
        );
        return _calculateDigest(structHash);
    }

    function _getSetProfileImageURITypedDataHash(
        uint256 profileId,
        string memory imageURI,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(Typehash.SET_PROFILE_IMAGE_URI, profileId, keccak256(bytes(imageURI)), nonce, deadline)
        );
        return _calculateDigest(structHash);
    }

    function _getSetFollowNFTURITypedDataHash(
        uint256 profileId,
        string memory followNFTURI,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(Typehash.SET_FOLLOW_NFT_URI, profileId, keccak256(bytes(followNFTURI)), nonce, deadline)
        );
        return _calculateDigest(structHash);
    }

    function _getBurnTypedDataHash(uint256 profileId, uint256 nonce, uint256 deadline) internal view returns (bytes32) {
        bytes32 structHash = keccak256(abi.encode(Typehash.BURN, profileId, nonce, deadline));
        return _calculateDigest(structHash);
    }

    function _getPostTypedDataHash(
        uint256 profileId,
        string memory contentURI,
        address collectModule,
        bytes memory collectModuleInitData,
        address referenceModule,
        bytes memory referenceModuleInitData,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(
                Typehash.POST,
                profileId,
                keccak256(bytes(contentURI)),
                collectModule,
                keccak256(collectModuleInitData),
                referenceModule,
                keccak256(referenceModuleInitData),
                nonce,
                deadline
            )
        );
        return _calculateDigest(structHash);
    }

    function _getPostTypedDataHash(
        Types.PostParams memory postParams,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        return
            _getPostTypedDataHash({
                profileId: postParams.profileId,
                contentURI: postParams.contentURI,
                collectModule: postParams.collectModule,
                collectModuleInitData: postParams.collectModuleInitData,
                referenceModule: postParams.referenceModule,
                referenceModuleInitData: postParams.referenceModuleInitData,
                nonce: nonce,
                deadline: deadline
            });
    }

    function _getCommentTypedDataHash(
        uint256 profileId,
        string memory contentURI,
        uint256 pointedProfileId,
        uint256 pointedPubId,
        uint256 referrerProfileId,
        uint256 referrerPubId,
        bytes memory referenceModuleData,
        address collectModule,
        bytes memory collectModuleInitData,
        address referenceModule,
        bytes memory referenceModuleInitData,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(
                Typehash.COMMENT,
                profileId,
                keccak256(bytes(contentURI)),
                pointedProfileId,
                pointedPubId,
                referrerProfileId,
                referrerPubId,
                keccak256(referenceModuleData),
                collectModule,
                keccak256(collectModuleInitData),
                referenceModule,
                keccak256(referenceModuleInitData),
                nonce,
                deadline
            )
        );
        return _calculateDigest(structHash);
    }

    function _getCommentTypedDataHash(
        Types.CommentParams memory commentParams,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        return
            _getCommentTypedDataHash({
                profileId: commentParams.profileId,
                contentURI: commentParams.contentURI,
                pointedProfileId: commentParams.pointedProfileId,
                pointedPubId: commentParams.pointedPubId,
                referrerProfileId: 0,
                referrerPubId: 0,
                referenceModuleData: commentParams.referenceModuleData,
                collectModule: commentParams.collectModule,
                collectModuleInitData: commentParams.collectModuleInitData,
                referenceModule: commentParams.referenceModule,
                referenceModuleInitData: commentParams.referenceModuleInitData,
                nonce: nonce,
                deadline: deadline
            });
    }

    function _getMirrorTypedDataHash(
        uint256 profileId,
        uint256 pointedProfileId,
        uint256 pointedPubId,
        uint256 referrerProfileId,
        uint256 referrerPubId,
        bytes memory referenceModuleData,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(
                Typehash.MIRROR,
                profileId,
                pointedProfileId,
                pointedPubId,
                referrerProfileId,
                referrerPubId,
                keccak256(referenceModuleData),
                nonce,
                deadline
            )
        );
        return _calculateDigest(structHash);
    }

    function _getMirrorTypedDataHash(
        Types.MirrorParams memory mirrorParams,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        return
            _getMirrorTypedDataHash({
                profileId: mirrorParams.profileId,
                pointedProfileId: mirrorParams.pointedProfileId,
                pointedPubId: mirrorParams.pointedPubId,
                referrerProfileId: 0,
                referrerPubId: 0,
                referenceModuleData: mirrorParams.referenceModuleData,
                nonce: nonce,
                deadline: deadline
            });
    }

    function _getFollowTypedDataHash(
        uint256 followerProfileId,
        uint256[] memory idsOfProfilesToFollow,
        uint256[] memory followTokenIds,
        bytes[] memory datas,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        uint256 dataLength = datas.length;
        bytes32[] memory dataHashes = new bytes32[](dataLength);
        for (uint256 i = 0; i < dataLength; ) {
            dataHashes[i] = keccak256(datas[i]);
            unchecked {
                ++i;
            }
        }

        bytes32 structHash = keccak256(
            abi.encode(
                Typehash.FOLLOW,
                followerProfileId,
                keccak256(abi.encodePacked(idsOfProfilesToFollow)),
                keccak256(abi.encodePacked(followTokenIds)),
                keccak256(abi.encodePacked(dataHashes)),
                nonce,
                deadline
            )
        );
        return _calculateDigest(structHash);
    }

    function _getCollectTypedDataHash(
        Types.CollectParams memory collectParams,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(
                Typehash.COLLECT,
                collectParams.publicationCollectedProfileId,
                collectParams.publicationCollectedId,
                collectParams.collectorProfileId,
                collectParams.referrerProfileId,
                collectParams.referrerPubId,
                keccak256(collectParams.collectModuleData),
                nonce,
                deadline
            )
        );
        return _calculateDigest(structHash);
    }

    function _calculateDigest(bytes32 structHash) internal view returns (bytes32) {
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainSeparator, structHash));
        return digest;
    }

    function _getSigStruct(
        uint256 pKey,
        bytes32 digest,
        uint256 deadline
    ) internal returns (Types.EIP712Signature memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pKey, digest);
        return Types.EIP712Signature(vm.addr(pKey), v, r, s, deadline);
    }

    function _getSigStruct(
        address signer,
        uint256 pKey,
        bytes32 digest,
        uint256 deadline
    ) internal returns (Types.EIP712Signature memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pKey, digest);
        return Types.EIP712Signature(signer, v, r, s, deadline);
    }

    function _toUint256Array(uint256 n) internal pure returns (uint256[] memory) {
        uint256[] memory ret = new uint256[](1);
        ret[0] = n;
        return ret;
    }

    function _toUint256Array(uint256 n0, uint256 n1) internal pure returns (uint256[] memory) {
        uint256[] memory ret = new uint256[](2);
        ret[0] = n0;
        ret[1] = n1;
        return ret;
    }

    function _toBytesArray(bytes memory b) internal pure returns (bytes[] memory) {
        bytes[] memory ret = new bytes[](1);
        ret[0] = b;
        return ret;
    }

    function _toBytesArray(bytes memory b0, bytes memory b1) internal pure returns (bytes[] memory) {
        bytes[] memory ret = new bytes[](2);
        ret[0] = b0;
        ret[1] = b1;
        return ret;
    }

    function _toBoolArray(bool b) internal pure returns (bool[] memory) {
        bool[] memory ret = new bool[](1);
        ret[0] = b;
        return ret;
    }

    function _toBoolArray(bool b0, bool b1) internal pure returns (bool[] memory) {
        bool[] memory ret = new bool[](2);
        ret[0] = b0;
        ret[1] = b1;
        return ret;
    }

    function _toAddressArray(address a) internal pure returns (address[] memory) {
        address[] memory ret = new address[](1);
        ret[0] = a;
        return ret;
    }

    function _toAddressArray(address a0, address a1) internal pure returns (address[] memory) {
        address[] memory ret = new address[](2);
        ret[0] = a0;
        ret[1] = a1;
        return ret;
    }

    // Internal functions

    function _post(Types.PostParams memory postParams) internal returns (uint256) {
        return hub.post(postParams);
    }

    function _comment(Types.CommentParams memory commentParams) internal returns (uint256) {
        return hub.comment(commentParams);
    }

    function _mirror(Types.MirrorParams memory mirrorParams) internal returns (uint256) {
        return hub.mirror(mirrorParams);
    }

    function _collect(
        uint256 collectorProfileId,
        uint256 publisherProfileId,
        uint256 pubId,
        bytes memory data
    ) internal returns (uint256) {
        return
            hub.collect(
                Types.CollectParams({
                    publicationCollectedProfileId: publisherProfileId,
                    publicationCollectedId: pubId,
                    collectorProfileId: collectorProfileId,
                    referrerProfileId: 0,
                    referrerPubId: 0,
                    collectModuleData: data
                })
            );
    }

    function _postWithSig(
        Types.PostParams memory postParams,
        Types.EIP712Signature memory signature
    ) internal returns (uint256) {
        return hub.postWithSig(postParams, signature);
    }

    function _commentWithSig(
        Types.CommentParams memory commentParams,
        Types.EIP712Signature memory signature
    ) internal returns (uint256) {
        return hub.commentWithSig(commentParams, signature);
    }

    function _mirrorWithSig(
        Types.MirrorParams memory mirrorParams,
        Types.EIP712Signature memory signature
    ) internal returns (uint256) {
        return hub.mirrorWithSig(mirrorParams, signature);
    }

    function _collectWithSig(
        Types.CollectParams memory collectParams,
        Types.EIP712Signature memory signature
    ) internal returns (uint256) {
        return hub.collectWithSig(collectParams, signature);
    }

    function _follow(
        address msgSender,
        uint256 followerProfileId,
        uint256 idOfProfileToFollow,
        uint256 followTokenId,
        bytes memory data
    ) internal returns (uint256[] memory) {
        vm.prank(msgSender);
        return
            hub.follow(
                followerProfileId,
                _toUint256Array(idOfProfileToFollow),
                _toUint256Array(followTokenId),
                _toBytesArray(data)
            );
    }

    function _followWithSig(
        uint256 followerProfileId,
        uint256 idOfProfileToFollow,
        uint256 followTokenId,
        bytes memory data,
        Types.EIP712Signature memory signature
    ) internal returns (uint256[] memory) {
        return
            hub.followWithSig(
                followerProfileId,
                _toUint256Array(idOfProfileToFollow),
                _toUint256Array(followTokenId),
                _toBytesArray(data),
                signature
            );
    }

    function _createProfile(address newProfileOwner) internal returns (uint256) {
        Types.CreateProfileParams memory CreateProfileParams = Types.CreateProfileParams({
            to: newProfileOwner,
            imageURI: mockCreateProfileParams.imageURI,
            followModule: mockCreateProfileParams.followModule,
            followModuleInitData: mockCreateProfileParams.followModuleInitData,
            followNFTURI: mockCreateProfileParams.followNFTURI
        });

        return hub.createProfile(CreateProfileParams);
    }

    function _setState(Types.ProtocolState newState) internal {
        hub.setState(newState);
    }

    function _getState() internal view returns (Types.ProtocolState) {
        return hub.getState();
    }

    function _setEmergencyAdmin(address newEmergencyAdmin) internal {
        hub.setEmergencyAdmin(newEmergencyAdmin);
    }

    function _transferProfile(address msgSender, address from, address to, uint256 tokenId) internal {
        vm.prank(msgSender);
        hub.transferFrom(from, to, tokenId);
    }

    function _changeDelegatedExecutorsConfig(
        address msgSender,
        uint256 profileId,
        address executor,
        bool approved
    ) internal {
        vm.prank(msgSender);
        hub.changeCurrentDelegatedExecutorsConfig({
            delegatorProfileId: profileId,
            executors: _toAddressArray(executor),
            approvals: _toBoolArray(approved)
        });
    }

    function _setFollowModule(
        address msgSender,
        uint256 profileId,
        address followModule,
        bytes memory followModuleInitData
    ) internal {
        vm.prank(msgSender);
        hub.setFollowModule(profileId, followModule, followModuleInitData);
    }

    function _setFollowModuleWithSig(
        uint256 profileId,
        address followModule,
        bytes memory followModuleInitData,
        Types.EIP712Signature memory signature
    ) internal {
        hub.setFollowModuleWithSig(profileId, followModule, followModuleInitData, signature);
    }

    function _setProfileImageURI(address msgSender, uint256 profileId, string memory imageURI) internal {
        vm.prank(msgSender);
        hub.setProfileImageURI(profileId, imageURI);
    }

    function _setProfileImageURIWithSig(
        uint256 profileId,
        string memory imageURI,
        Types.EIP712Signature memory signature
    ) internal {
        hub.setProfileImageURIWithSig(profileId, imageURI, signature);
    }

    function _setFollowNFTURI(address msgSender, uint256 profileId, string memory followNFTURI) internal {
        vm.prank(msgSender);
        hub.setFollowNFTURI(profileId, followNFTURI);
    }

    function _setFollowNFTURIWithSig(
        uint256 profileId,
        string memory followNFTURI,
        Types.EIP712Signature memory signature
    ) internal {
        hub.setFollowNFTURIWithSig(profileId, followNFTURI, signature);
    }

    function _burn(address msgSender, uint256 profileId) internal {
        vm.prank(msgSender);
        hub.burn(profileId);
    }

    function _getPub(uint256 profileId, uint256 pubId) internal view returns (Types.Publication memory) {
        return hub.getPub(profileId, pubId);
    }

    function _getSigNonce(address signer) internal view returns (uint256) {
        return hub.nonces(signer);
    }

    function _getPubCount(uint256 profileId) internal view returns (uint256) {
        return hub.getPubCount(profileId);
    }

    function _getCollectCount(uint256 profileId, uint256 pubId) internal view returns (uint256) {
        address collectNft = hub.getCollectNFT(profileId, pubId);
        if (collectNft == address(0)) {
            return 0;
        } else {
            return CollectNFT(collectNft).totalSupply();
        }
    }
}