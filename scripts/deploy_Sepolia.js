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

  const TONAddress = '0xa30fe40285b8f5c0457dbc3b7c8a280373c40044'; //Sepolia TON address
  const TOSAddress = '0xff3ef745d9878afe5934ff0b130868afddbc58e8'; //Sepolia TOS address
  const TONAmount = ethers.BigNumber.from("4000000000000000000000"); //4000 in wei
  const TOSAmount = ethers.BigNumber.from("4000000000000000000000"); //4000 in wei
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
