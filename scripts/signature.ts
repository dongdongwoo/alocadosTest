import "@nomiclabs/hardhat-ethers";
import "@openzeppelin/hardhat-upgrades";
import { ethers } from "ethers";
async function main() {
    let pk = require('../secrets.json').PrivateKey;

// Create a wallet to sign the message with
    let wallet = new ethers.Wallet(pk);

    console.log(wallet.address);

    let message = "test";
    const messageHash = ethers.utils.solidityKeccak256(["string"], [message])
    console.log("messageHash ", messageHash)
    const messageHashBinary = ethers.utils.arrayify(messageHash)
    console.log("messageHashBinary ", messageHashBinary)
// Sign the string message
    let flatSig = await wallet.signMessage(messageHash);
    let sig = ethers.utils.splitSignature(flatSig);
    console.log(flatSig)
    console.log(sig)

    console.log("handle message ",ethers.utils.hashMessage(messageHash))
    const verified = ethers.utils.verifyMessage(messageHash, flatSig)

    console.log("owner    ", wallet.address)
    console.log("verified ", verified)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
