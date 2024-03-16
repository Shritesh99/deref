require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-chai-matchers");
require('dotenv').config()

const PRIVATE_KEYS = (process.env.PRIVATE_KEYS || "").split(",")

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    base_sepolia: {
      url: process.env.BASE_SEPOLIA_RPC_URL,
      accounts: PRIVATE_KEYS,
    }
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 2000,
      },
    },
  },
};
