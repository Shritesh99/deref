const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Sample", () => {
  async function deployContracts() {
    const initialSupply = ethers.parseEther("1000");
    const signers = await ethers.getSigners();

    const erc20 = await ethers.deployContract(
      "MyERC20",
      [initialSupply, "Test Token", "TT"],
      {}
    );

    const ReferralSystemFactory = await ethers.getContractFactory(
      "ReferralSystemSample"
    );
    const referralSystem = await ReferralSystemFactory.deploy(erc20.target);

    await erc20.transfer(referralSystem.target, initialSupply);

    return { signers, erc20, referralSystem };
  }

  describe("refer", function () {
    it("should give 100 token to referer and myself", async () => {
      const { signers, erc20, referralSystem } = await deployContracts();

      const from = signers[0].address;
      const to = signers[1].address;

      await expect(referralSystem.refer(to)).to.changeTokenBalances(
        erc20,
        [from, to],
        [100, 100]
      );
    });

    it("cannot refer multiple times", async () => {
      const { signers, referralSystem } = await deployContracts();

      const from = signers[0].address;
      const to = signers[1].address;

      await expect(referralSystem.refer(to)).not.to.be.reverted;
      await expect(referralSystem.refer(to)).to.be.revertedWith(
        "refered already"
      );
    });
  });

  describe("refer with 2nd distribution", function () {
    it("should give 100 token to referer and myself", async () => {
      const { signers, erc20, referralSystem } = await deployContracts();

      const alice = signers[0];
      const bob = signers[1];
      const charlie = signers[2];
      const david = signers[3];

      // bob -> alice
      await expect(
        referralSystem.connect(bob).refer(alice)
      ).to.changeTokenBalances(erc20, [alice, bob], [100, 100]);

      // charlie -> bob
      await expect(
        referralSystem.connect(charlie).refer(bob)
      ).to.changeTokenBalances(erc20, [alice, bob, charlie], [30, 100, 70]);

      // david -> charlie
      await expect(
        referralSystem.connect(david).refer(charlie)
      ).to.changeTokenBalances(erc20, [bob, charlie, david], [30, 100, 70]);
    });
  });
});
