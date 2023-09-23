// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Lottie {
    address public manager;
    address[] public players;
    mapping(address => uint) public enterCounts;

    constructor(){}

    modifier restricted {
        require(msg.sender == manager, "!manager");
        _;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encode(block.timestamp, players)));
    }

    function lottery() public {
        manager = msg.sender;
    }

    function playerLength() public view returns (uint){
        return players.length;
    }

    function enter() public payable {
        require(msg.value > .01 ether);
        require(enterCounts[msg.sender] < 3);

        players.push(msg.sender);
        enterCounts[msg.sender]++;
    }

    function pickWinner() public restricted returns (uint){
        uint index = random() % players.length;
        uint winnerBalance = address(this).balance / 3;

        payable(players[index]).transfer(winnerBalance);
        if (index > 2) {
            payable(players[index - 1]).transfer(winnerBalance);
            payable(players[index - 2]).transfer(winnerBalance);
        } else {
            payable(players[index + 1]).transfer(winnerBalance);
            payable(players[index + 2]).transfer(winnerBalance);
        }

        for (uint i=0; i < players.length; i++) {
            delete enterCounts[players[i]];
        }
        players = new address[](0);

        return index;
    }
}
