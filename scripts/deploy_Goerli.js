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
  const TONAmount = ethers.BigNumber.from("100000000000000000000"); //100 in wei
  const TOSAmount = ethers.BigNumber.from("100000000000000000000"); //100 in wei
  const waitTime = 86400; //1 day unix epoch time
  
  const Faucet = await ethers.getContractFactory("Faucet");
  console.log("Deploying Faucet...");
  const faucet = await Faucet.deploy(TONAddress, TOSAddress, TONAmount, TOSAmount, waitTime);
  await faucet.deployed();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
