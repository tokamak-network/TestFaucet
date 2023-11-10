// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers } = require("hardhat");
require("dotenv").config();
async function main() {
  //const deployer = await ethers.getSigners();

  const TONAddress = '0x68c1F9620aeC7F2913430aD6daC1bb16D8444F00'; //Goerli TON address
  const TOSAddress = '0x67F3bE272b1913602B191B3A68F7C238A2D81Bb9'; //Goerli TOS address
  

  const TONToken = await ethers.getContractAt('TON', TONAddress);
  const TOSToken = await ethers.getContractAt('TOS', TOSAddress);
  const TONdecimals = await TONToken.decimals();
  const TOSdecimals = await TOSToken.decimals();
  const recipientAddress = "0xA1b84Ca44Faf9C1654f476720A0BB2474e18886D";
  const transferAmount = ethers.BigNumber.from("10000000000000000000000"); //1,000 in wei
    
  await TONToken.transfer(recipientAddress, transferAmount, TONdecimals);
  await TONToken.transfer(recipientAddress, transferAmount, TOSdecimals);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
