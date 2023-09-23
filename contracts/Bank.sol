// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./libraries/SafeERC20.sol";
import "./libraries/Math.sol";

contract Bank {
    using SafeERC20 for IERC20;

    struct BankInfo {
        address token;
        uint balance;
        uint depositedTime;
    }

    mapping(address => BankInfo) public bankInfo;
    uint public constant exchangeRatePerSecond = 229197101465600000000;

    constructor() {}

    function amountOf(address account) public view returns (uint){
        return bankInfo[account].balance;
    }

    function rewards(address account) public view returns (uint){
        uint duration = block.timestamp -  bankInfo[account].depositedTime;
        uint interestRateForDuration = Math.rpow(
            exchangeRatePerSecond + 1e27,
            duration,
            1e27
        );

        uint pendingReward = (bankInfo[account].balance * (interestRateForDuration - 1e27)) / 1e27;
        return pendingReward;
    }

    function deposit(address token, uint amount) external payable {
        require(bankInfo[msg.sender].balance == 0, "already deposit!");

        if (token == address(0)) {
            amount = msg.value;
        } else {
            IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        }

        bankInfo[msg.sender].balance = amount;
        bankInfo[msg.sender].depositedTime = block.timestamp;
        bankInfo[msg.sender].token = token;
    }

    function withdraw(address token) external {
        require(bankInfo[msg.sender].balance > 0, "make a deposit first");
        uint totalWithdraw = amountOf(msg.sender) + rewards(msg.sender);

        bankInfo[msg.sender].balance = 0;

        if (token == address(0)) {
            SafeERC20.safeTransferETH(msg.sender, totalWithdraw);
        } else {
            IERC20(token).safeTransfer(msg.sender, totalWithdraw);
        }
    }
}
