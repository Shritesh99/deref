const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("DeRefModule", (m) => {
	const initialSupply = ethers.parseEther("1000");

	const erc20 = m.contract("MyERC20", [initialSupply, "Fan Token", "FT"]);
	const ultraVerifier = m.contract("UltraVerifier");

	const deref = m.contract("ReferralSystem", [
		erc20,
		ultraVerifier,
		"0x42FF98C4E85212a5D31358ACbFe76a621b50fC02",
		"app_staging_64f7baac41050d666259b740f95a01f4",
		"deref-1",
	]);

	return {
		deref,
	};
});
