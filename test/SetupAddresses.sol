pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "contracts/interfaces/IERC20.sol";

import "contracts/Bank.sol";
import "contracts/Lottie.sol";
import "contracts/ECDSA.sol";

contract SetupAddresses is Test {
    address deadAddress = 0x000000000000000000000000000000000000dEaD;
    Bank bank;
    Lottie lottie;
    ECDSA ecdsa;

    IERC20 DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    address deployer;
    address user1;
    address user2;
    address user3;
    address user4;
    address user5;
    address sigUser = 0x9d0988876697ce0A3313677f720796c126aEF419;


    function setupAddresses() internal {
        deployer = address(0x5123);
        user1 = address(0x5123 + 1);
        user2 = address(0x5123 + 2);
        user3 = address(0x5123 + 3);
        user4 = address(0x5123 + 4);
        user5 = address(0x5123 + 5);

        vm.startPrank(deployer);
        {
            bank = new Bank();
            lottie = new Lottie();
            ecdsa = new ECDSA();
        }
        vm.stopPrank();

        _setUserLabel();
        _setContractLabel();
        _setTokenLabel();
    }

    function _setUserLabel() private {
        vm.label(deployer, "DEPLOYER");
        vm.label(user1, "USER1");
        vm.label(user2, "USER2");
    }

    function _setContractLabel() private {
        // Contract label
        vm.label(address(bank), "bank");
        vm.label(address(lottie), "lottie");
        vm.label(address(ecdsa), "ecdsa");
    }

    function _setTokenLabel() private {
        vm.label(address(DAI), "DAI Token");
    }
}

