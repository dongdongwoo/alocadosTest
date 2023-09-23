// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../Setup.sol";

contract ECDSATest is Setup {
    bytes public signature = hex"702e78d0e2d551816158bd48ac7350a8df8df945da15720ad90ae3ac5fb07759180f10567f50b100a987042d8ce274c7a674e5ca7bcb478b7245accc3da9b1c61b";
    bytes32 public message = hex"ea72b5ee3d0fc31b2b455d50215dba16b1ee11625977a44f72830d578fa61af8";

    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function _testEcdsaDeposit(address token, uint amount) internal {
        vm.startPrank(sigUser);
        {
            // signMessage 0x702e78d0e2d551816158bd48ac7350a8df8df945da15720ad90ae3ac5fb07759180f10567f50b100a987042d8ce274c7a674e5ca7bcb478b7245accc3da9b1c61b
            _charge(token, sigUser, amount * 2);
            if (token == address(0)) {
                // 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb658
                ecdsa.deposit{value: amount}(message, signature, token, amount);
            } else {
                IERC20(token).approve(address(ecdsa), amount);
                ecdsa.deposit(message, signature, token, amount);
            }
        }
        vm.stopPrank();
    }

    function testEcdsaDeposit() public {
        _testEcdsaDeposit(address(DAI), 10e18);
        _testEcdsaDeposit(address(0), 10e18);
    }

    function testEcdsaWithdraw() public {
        _testEcdsaDeposit(address(DAI), 10e18);
        uint beforeWithdrawAmount = IERC20(address(DAI)).balanceOf(sigUser);
        console.log("beforeWithdrawAmount", beforeWithdrawAmount);

        vm.startPrank(sigUser);
        {
            ecdsa.withdraw(signature);
        }
        vm.stopPrank();

        uint afterWithdrawAmount = IERC20(address(DAI)).balanceOf(sigUser);
        console.log("afterWithdrawAmount", afterWithdrawAmount);
    }
}