import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv";
import { configDotenv } from "dotenv";

configDotenv();

const { API_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  defaultNetwork: "hardhat",
  networks: {
	hardhat: {},
	mumbai: {
  	url: 'https://polygon-mumbai.g.alchemy.com/v2/FHabG9WmNe3WxT661DiClJqs4XTN4WnM',
  	accounts: [`0x4afaaac3b7568f3e58194daff67500b0a0ae310ff3bcfd93da6c8f5038c5d6b7`]
	}
  }
};

export default config;
