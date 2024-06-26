// import { HardhatUserConfig } from "hardhat/config";
require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000
      }
    }
  },
  networks: {
    goerli: {
      url: `${process.env.ETH_NODE_URI_goerli}`,
      accounts: [process.env.PRIVATE_KEY]
    },
    sepolia: {
      url: `${process.env.ETH_NODE_URI_sepolia}`,
      accounts: [process.env.PRIVATE_KEY]
    }
  },

  etherscan: {
    apiKey: {
      goerli: `${process.env.ETHERSCAN_API_KEY}`
    },
    apiKey: {
      sepolia: `${process.env.ETHERSCAN_API_KEY}`
    }
  },

  sourcify: {
    // Disabled by default
    // Doesn't need an API key
    enabled: true
  }
};