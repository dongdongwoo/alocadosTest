// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "./SetupAddresses.sol";

contract Setup is Test, SetupAddresses {
    receive() external payable {}

    uint256 private _setupSnapshotId;

    function setUp() public {
        setupAddresses();
        _setupSnapshotId = vm.snapshot();

        vm.prank(deployer);
        lottie.lottery();

        _charge(address(0), address(bank), 100e18);
        _charge(address(DAI), address(bank), 100e18);
    }

    function _charge(address token, address user, uint amount) internal {
        if (token == address(0)) {
            deal(user, amount);
        } else {
            deal(token, user, amount);
        }
    }

    function _timeElapse(uint timeDelta) internal {
        vm.warp(block.timestamp + timeDelta);
        vm.roll(block.number + timeDelta);
    }

    function reset() internal {
        vm.revertTo(_setupSnapshotId);
        // revertTo "deletes the given snapshot, as well as any snapshots taken after"
        _setupSnapshotId = vm.snapshot();
    }
}

