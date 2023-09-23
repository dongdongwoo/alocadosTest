// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../Setup.sol";

contract LottieTest is Setup {
    function _testEnter() internal {
        _charge(address(0), user1, 1 ether);
        _charge(address(0), user2, 1 ether);
        _charge(address(0), user3, 1 ether);
        _charge(address(0), user4, 1 ether);
        _charge(address(0), user5, 1 ether);

        vm.startPrank(user1);
        {
            lottie.enter{value: 0.2 ether}();
        }
        vm.stopPrank();

        vm.startPrank(user2);
        {
            lottie.enter{value: 0.2 ether}();
            lottie.enter{value: 0.2 ether}();
        }
        vm.stopPrank();

        vm.startPrank(user3);
        {
            lottie.enter{value: 0.2 ether}();
            lottie.enter{value: 0.2 ether}();
            lottie.enter{value: 0.2 ether}();
        }
        vm.stopPrank();

        vm.startPrank(user4);
        {
            lottie.enter{value: 0.2 ether}();
        }
        vm.stopPrank();

        vm.startPrank(user5);
        {
            lottie.enter{value: 0.2 ether}();
            lottie.enter{value: 0.2 ether}();
        }
        vm.stopPrank();
    }

    function testEnter() external {
        _testEnter();
    }

    function testPickWinner() external {
        _testEnter();

        address[] memory copyPlayers = new address[](lottie.playerLength());
        for (uint i=0; i < lottie.playerLength(); i++) {
            copyPlayers[i] = lottie.players(i);
        }

        uint winnerIndex;

        for (uint i=0; i < copyPlayers.length; i++) {
            console.log(copyPlayers[i], copyPlayers[i].balance);
        }

        vm.startPrank(deployer);
        {
            lottie.lottery();
            winnerIndex = lottie.pickWinner();
        }
       vm.stopPrank();

        console.log("winner Index : ", winnerIndex);
        console.log("--");
        for (uint i=0; i < copyPlayers.length; i++) {
            console.log(copyPlayers[i], copyPlayers[i].balance);
        }

        console.log("--");
        console.log(lottie.playerLength());
    }
}