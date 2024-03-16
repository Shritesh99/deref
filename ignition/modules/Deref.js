const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("DeRefModule", (m) => {
	const initialSupply = ethers.parseEther("1000");
	const erc20Factory = m.contract("MyERC20", [
		initialSupply,
		"Test Token",
		"TT",
	]);
	const erc20Deploy = m.call(erc20Factory, "deploy");
	const erc20Address = m.readEventArgument(erc20Deploy, "Deployed", "addr");

	const ultraVerifierFactory = m.contract("UltraVerifier");
	const ultraVerifierDeploy = m.call(ultraVerifierFactory, "deploy");
	const ultraVerifierAddress = m.readEventArgument(
		ultraVerifierDeploy,
		"Deployed",
		"addr"
	);

	const refFactory = m.contract("ReferralSystem", [
		erc20Address,
		ultraVerifierAddress,
	]);
	const refDeploy = m.call(refFactory, "deploy");
	const address = m.readEventArgument(refDeploy, "Deployed", "addr");

	return {
		address,
	};
});
