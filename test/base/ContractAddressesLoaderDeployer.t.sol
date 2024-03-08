// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import 'forge-std/Test.sol';
import {CollectPublicationAction} from 'contracts/modules/act/collect/CollectPublicationAction.sol';
import {CollectNFT} from 'contracts/modules/act/collect/CollectNFT.sol';
import {ForkManagement} from 'test/helpers/ForkManagement.sol';
import {LensHub} from 'contracts/LensHub.sol';
// import {FeeFollowModule} from 'contracts/modules/follow/FeeFollowModule.sol';
import {RevertFollowModule} from 'contracts/modules/follow/RevertFollowModule.sol';
import {DegreesOfSeparationReferenceModule} from 'contracts/modules/reference/DegreesOfSeparationReferenceModule.sol';
import {FollowerOnlyReferenceModule} from 'contracts/modules/reference/FollowerOnlyReferenceModule.sol';
import {TokenGatedReferenceModule} from 'contracts/modules/reference/TokenGatedReferenceModule.sol';
import {Governance} from 'contracts/misc/access/Governance.sol';
import {ProxyAdmin} from 'contracts/misc/access/ProxyAdmin.sol';
import {ModuleRegistry} from 'contracts/misc/ModuleRegistry.sol';
import {LibString} from 'solady/utils/LibString.sol';

import {ProfileTokenURI} from 'contracts/misc/token-uris/ProfileTokenURI.sol';
import {FollowTokenURI} from 'contracts/misc/token-uris/FollowTokenURI.sol';
import {HandleTokenURI} from 'contracts/misc/token-uris/HandleTokenURI.sol';

contract ContractAddressesLoaderDeployer is Test, ForkManagement {
    using stdJson for string;

    // TODO: Move this to helpers somewhere
    function findModuleHelper(
        Module[] memory modules,
        string memory moduleNameToFind
    ) internal pure returns (Module memory) {
        for (uint256 i = 0; i < modules.length; i++) {
            if (LibString.eq(modules[i].name, moduleNameToFind)) {
                return modules[i];
            }
        }
        revert('Module not found');
    }

    // add this to be excluded from coverage report
    function testContractAddressesLoaderDeployer() public {}

    function loadOrDeploy_GovernanceContract() internal {
        if (fork) {
            if (keyExists(json, string(abi.encodePacked('.', forkEnv, '.GovernanceContract')))) {
                governanceContract = Governance(
                    json.readAddress(string(abi.encodePacked('.', forkEnv, '.GovernanceContract')))
                );
            } else {
                console.log('GovernanceContract key does not exist');
                if (forkVersion == 1) {
                    console.log('No GovernanceContract address found - deploying new one');
                    governanceContract = new Governance(address(hub), governanceMultisig);
                } else {
                    console.log('No GovernanceContract address found in addressBook, which is required for V2');
                    revert('No GovernanceContract address found in addressBook, which is required for V2');
                }
            }
        } else {
            governanceContract = new Governance(address(hub), governanceMultisig);
        }
    }

    function loadOrDeploy_ProxyAdminContract() internal {
        if (fork) {
            if (keyExists(json, string(abi.encodePacked('.', forkEnv, '.ProxyAdminContract')))) {
                proxyAdminContract = ProxyAdmin(
                    json.readAddress(string(abi.encodePacked('.', forkEnv, '.ProxyAdminContract')))
                );
            } else {
                console.log('ProxyAdminContract key does not exist');
                if (forkVersion == 1) {
                    console.log('No ProxyAdminContract address found - deploying new one');
                    proxyAdminContract = new ProxyAdmin(address(hub), address(hubImpl), proxyAdmin);
                } else {
                    console.log('No ProxyAdminContract address found in addressBook, which is required for V2');
                    revert('No ProxyAdminContract address found in addressBook, which is required for V2');
                }
            }
        } else {
            proxyAdminContract = new ProxyAdmin(address(hub), address(hubImpl), proxyAdmin);
        }
    }

    function loadOrDeploy_ModuleRegistryContract() internal {
        if (fork) {
            if (keyExists(json, string(abi.encodePacked('.', forkEnv, '.ModuleRegistry')))) {
                moduleRegistry = ModuleRegistry(
                    json.readAddress(string(abi.encodePacked('.', forkEnv, '.ModuleRegistry')))
                );
            } else {
                console.log('ModuleRegistry key does not exist');
                if (forkVersion == 1) {
                    console.log('No ModuleRegistry address found - deploying new one');
                    moduleRegistry = new ModuleRegistry();
                } else {
                    console.log('No ModuleRegistry address found in addressBook, which is required for V2');
                    revert('No ModuleRegistry address found in addressBook, which is required for V2');
                }
            }
        } else {
            moduleRegistry = new ModuleRegistry(); // TODO: Maybe make it upgradeable if needed
        }
    }

    function loadOrDeploy_CollectPublicationAction() internal returns (address, address) {
        address collectNFTImpl;
        CollectPublicationAction collectPublicationAction;

        // Deploy CollectPublicationAction
        if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.CollectNFT')))) {
            collectNFTImpl = json.readAddress(string(abi.encodePacked('.', forkEnv, '.CollectNFT')));
            console.log('Found CollectNFT deployed at:', address(collectNFTImpl));
        }

        if (fork) {
            Module[] memory actModules = abi.decode(
                vm.parseJson(json, string(abi.encodePacked('.', forkEnv, '.Modules.v2.act'))),
                (Module[])
            );
            if (actModules.length != 0) {
                collectPublicationAction = CollectPublicationAction(
                    findModuleHelper(actModules, 'CollectPublicationAction').addy
                );
                console.log('Found collectPublicationAction deployed at:', address(collectPublicationAction));
            }
        }

        // Both deployed - need to verify if they are linked
        if (collectNFTImpl != address(0) && address(collectPublicationAction) != address(0)) {
            if (CollectNFT(collectNFTImpl).ACTION_MODULE() == address(collectPublicationAction)) {
                console.log('CollectNFT and CollectPublicationAction already deployed and linked');
                return (collectNFTImpl, address(collectPublicationAction));
            }
        }

        uint256 deployerNonce = vm.getNonce(deployer);

        address predictedCollectPublicationAction = computeCreateAddress(deployer, deployerNonce);
        address predictedCollectNFTImpl = computeCreateAddress(deployer, deployerNonce + 1);

        vm.startPrank(deployer);
        collectPublicationAction = new CollectPublicationAction(address(hub), predictedCollectNFTImpl, address(this));
        collectNFTImpl = address(new CollectNFT(address(hub), address(collectPublicationAction)));
        vm.stopPrank();

        assertEq(
            address(collectPublicationAction),
            predictedCollectPublicationAction,
            'CollectPublicationAction deployed address mismatch'
        );
        assertEq(collectNFTImpl, predictedCollectNFTImpl, 'CollectNFTImpl deployed address mismatch');

        vm.label(address(collectPublicationAction), 'CollectPublicationAction');
        vm.label(collectNFTImpl, 'CollectNFTImpl');

        return (collectNFTImpl, address(collectPublicationAction));
    }

    // function loadOrDeploy_SeaDropMintPublicationAction() internal returns (address) {}

    // function loadOrDeploy_FeeFollowModule() internal returns (address) {
    //     address feeFollowModule;
    //     if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.FeeFollowModule')))) {
    //         feeFollowModule = json.readAddress(string(abi.encodePacked('.', forkEnv, '.FeeFollowModule')));
    //         console.log('Testing against already deployed module at:', feeFollowModule);
    //     } else {
    //         vm.prank(deployer);
    //         feeFollowModule = address(new FeeFollowModule(address(hub), address(moduleRegistry), address(this)));
    //     }
    //     return feeFollowModule;
    // }

    function loadOrDeploy_RevertFollowModule() internal returns (address) {
        address revertFollowModule;
        if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.RevertFollowModule')))) {
            revertFollowModule = json.readAddress(string(abi.encodePacked('.', forkEnv, '.RevertFollowModule')));
            console.log('Testing against already deployed module at:', revertFollowModule);
        } else {
            vm.prank(deployer);
            revertFollowModule = address(new RevertFollowModule(address(this)));
        }
        return revertFollowModule;
    }

    function loadOrDeploy_DegreesOfSeparationReferenceModule() internal returns (address) {
        address degreesOfSeparationReferenceModule;
        if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.DegreesOfSeparationReferenceModule')))) {
            degreesOfSeparationReferenceModule = json.readAddress(
                string(abi.encodePacked('.', forkEnv, '.DegreesOfSeparationReferenceModule'))
            );
            console.log('Testing against already deployed module at:', degreesOfSeparationReferenceModule);
        } else {
            vm.prank(deployer);
            degreesOfSeparationReferenceModule = address(
                new DegreesOfSeparationReferenceModule(hubProxyAddr, address(this))
            );
        }
        return degreesOfSeparationReferenceModule;
    }

    function loadOrDeploy_FollowerOnlyReferenceModule() internal returns (address) {
        address followerOnlyReferenceModule;
        if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.FollowerOnlyReferenceModule')))) {
            followerOnlyReferenceModule = json.readAddress(
                string(abi.encodePacked('.', forkEnv, '.FollowerOnlyReferenceModule'))
            );
            console.log('Testing against already deployed module at:', followerOnlyReferenceModule);
        } else {
            vm.prank(deployer);
            followerOnlyReferenceModule = address(new FollowerOnlyReferenceModule(hubProxyAddr, address(this)));
        }
        return followerOnlyReferenceModule;
    }

    function loadOrDeploy_TokenGatedReferenceModule() internal returns (address) {
        address tokenGatedReferenceModule;
        if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.TokenGatedReferenceModule')))) {
            tokenGatedReferenceModule = json.readAddress(
                string(abi.encodePacked('.', forkEnv, '.TokenGatedReferenceModule'))
            );
            console.log('Testing against already deployed module at:', tokenGatedReferenceModule);
        } else {
            vm.prank(deployer);
            tokenGatedReferenceModule = address(new TokenGatedReferenceModule(hubProxyAddr, address(this)));
        }
        return tokenGatedReferenceModule;
    }

    function loadOrDeploy_ProfileTokenURIContract() internal returns (address) {
        address profileTokenURIContractAddress;
        if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.ProfileTokenURI')))) {
            profileTokenURIContractAddress = json.readAddress(
                string(abi.encodePacked('.', forkEnv, '.ProfileTokenURI'))
            );
            console.log(
                'Testing against already deployed ProfileTokenURI contract at:',
                profileTokenURIContractAddress
            );
        } else {
            vm.prank(deployer);
            profileTokenURIContractAddress = address(new ProfileTokenURI());
        }
        profileTokenURIContract = ProfileTokenURI(profileTokenURIContractAddress);
        return profileTokenURIContractAddress;
    }

    function loadOrDeploy_FollowTokenURIContract() internal returns (address) {
        address followTokenURIContractAddress;
        if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.FollowTokenURI')))) {
            followTokenURIContractAddress = json.readAddress(string(abi.encodePacked('.', forkEnv, '.FollowTokenURI')));
            console.log('Testing against already deployed FollowTokenURI contract at:', followTokenURIContractAddress);
        } else {
            vm.prank(deployer);
            followTokenURIContractAddress = address(new FollowTokenURI());
        }
        followTokenURIContract = FollowTokenURI(followTokenURIContractAddress);
        return followTokenURIContractAddress;
    }

    function loadOrDeploy_HandleTokenURIContract() internal returns (address) {
        address handleTokenURIContractAddress;
        if (fork && keyExists(json, string(abi.encodePacked('.', forkEnv, '.HandleTokenURI')))) {
            handleTokenURIContractAddress = json.readAddress(string(abi.encodePacked('.', forkEnv, '.HandleTokenURI')));
            console.log('Testing against already deployed HandleTokenURI contract at:', handleTokenURIContractAddress);
        } else {
            vm.prank(deployer);
            handleTokenURIContractAddress = address(new HandleTokenURI());
        }
        handleTokenURIContract = HandleTokenURI(handleTokenURIContractAddress);
        return handleTokenURIContractAddress;
    }
}
