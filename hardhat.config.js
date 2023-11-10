// import { HardhatUserConfig } from "hardhat/config";
require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 100
      }
    }
  },
  networks: {
    goerli: {
      url: `${process.env.ETH_NODE_URI_goerli}`,
      accounts: [process.env.PRIVATE_KEY]
    }
  },

  etherscan: {
    apiKey: {
      goerli: `${process.env.ETHERSCAN_API_KEY}`
    }
  },

  sourcify: {
    // Disabled by default
    // Doesn't need an API key
    enabled: true
  }
};