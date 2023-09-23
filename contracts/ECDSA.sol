// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./libraries/SafeERC20.sol";

contract ECDSA {
    using SafeERC20 for IERC20;

    struct EcdsaInfp {
        address token;
        uint balance;
    }

    mapping (address => EcdsaInfp) public ecdsaInfos;

    constructor(){}

    function recover(bytes32 message, bytes memory signature) public view returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (signature.length != 65) {
            return address(0);
        }

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        if (v != 27 && v!= 28) {
            return address(0);
        } else {
            address signer = ecrecover(message, v, r, s);
            return signer;
        }
    }

    function withdraw(bytes memory signatureHash) public {
        address signer = recover(getTestMsg(), signatureHash);
        require(signer == msg.sender, "!signer");

        uint amount = ecdsaInfos[msg.sender].balance;
        address token = ecdsaInfos[msg.sender].token;
        ecdsaInfos[msg.sender].balance = 0;

        if (token == address(0)) {
            SafeERC20.safeTransferETH(msg.sender, amount);
        } else {
            IERC20(token).safeTransfer(msg.sender, amount);
        }
    }

    function deposit(bytes32 message, bytes memory signature, address token, uint amount) public payable {
        require(recover(message, signature) != address(0), "!recover");
        if (token == address(0)) {
            amount = msg.value;
        } else {
            IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        }

        ecdsaInfos[msg.sender].balance += amount;
        ecdsaInfos[msg.sender].token = token;
    }

    function getTestMsg() internal pure returns (bytes32) {
        return hex"ea72b5ee3d0fc31b2b455d50215dba16b1ee11625977a44f72830d578fa61af8";
    }
}
