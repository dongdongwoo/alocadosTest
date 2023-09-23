// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../Setup.sol";

contract BankTest is Setup {
    function _testDeposit(address token, uint amount) internal {
        uint beforeDepositAmount = bank.amountOf(user1);
        console.log("beforeDepositAmount : ", beforeDepositAmount);

        vm.startPrank(user1);
        {
            _charge(token, user1, amount * 2);
            if (token == address(0)) {
                bank.deposit{value: amount}(token, amount);
            } else {
                IERC20(token).approve(address(bank), amount);
                bank.deposit(token, amount);
            }
        }
        vm.stopPrank();

        uint afterDepositAmount = bank.amountOf(user1);
        console.log("afterDepositAmount : ", afterDepositAmount);

        console.log("---");
    }

    function _testWithdraw(address token, uint amount) internal {
        _testDeposit(token, amount);

        _timeElapse(1 days);

        uint beforeBalance = bank.amountOf(user1);
        console.log("beforeBalance : ", beforeBalance);

        uint beforeReward = bank.rewards(user1);
        console.log("beforeReward : ", beforeReward);

        vm.startPrank(user1);
        {
            bank.withdraw(token);
        }
        vm.stopPrank();

        uint afterBalance = bank.amountOf(user1);
        console.log("afterBalance : ", afterBalance);

        uint afterReward = bank.rewards(user1);
        console.log("afterReward : ", afterReward);

        console.log("---");
    }

    function _testRewards(address token, uint amount) internal {
        _testDeposit(token, amount);

        uint beforeRewards = bank.rewards(user1);
        console.log("beforeRewards : ", beforeRewards);

        _timeElapse(1 days);

        uint afterRewards = bank.rewards(user1);
        console.log("afterRewards : ", afterRewards);

        console.log("---");
    }

    function testDeposit() external {
        _testDeposit(address(DAI), 100e18);
        reset();
        _testDeposit(address(0), 100e18);
        reset();
    }

    function testWithdraw() external {
        _testWithdraw(address(DAI), 100e18);
    }

    function testRewards() external {
        _testRewards(address(DAI), 100e18);
    }
}