// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import ERC20 interface
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ReferralSystemSample {
    uint256 constant REWARD_AMOUNT = 100;
    uint256 constant SECOND_REWARD_AMOUNT = 30;

    // Define ERC20 token contract address
    address public tokenAddress;

    mapping(address => address[]) public referrals;
    mapping(address => mapping(address => bool)) refered;

    // Mapping to track rewards earned by referrers
    mapping(address => uint256) public rewards;

    // Events to emit upon referral, reward distribution, and code generation
    event Referral(address indexed referrer, address indexed referee);
    event RewardDistributed(address indexed referrer, uint256 amount);

    // Constructor to set the ERC20 token address and ZK-SNARK verifier address
    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    // Function to retrieve total rewards earned by a referrer
    function getTotalRewards(address account) external view returns (uint256) {
        return rewards[account];
    }

    function refer(address referrer) external {
        require(refered[msg.sender][referrer] == false, "refered already");

        refered[msg.sender][referrer] = true;

        // first reward
        _distributeTo(referrer, REWARD_AMOUNT);

        // second reward
        bool isSuccess = _distributeSecondReward(
            referrer,
            SECOND_REWARD_AMOUNT
        );

        // reward for myself
        if (isSuccess) {
            _distributeTo(msg.sender, REWARD_AMOUNT - SECOND_REWARD_AMOUNT); // +70 to myself
        } else {
            _distributeTo(msg.sender, REWARD_AMOUNT); // +100 to myself
        }

        referrals[msg.sender].push(referrer);
    }

    function _distributeTo(address target, uint256 amount) internal {
        IERC20(tokenAddress).transfer(target, amount);
        rewards[target] += amount;
        emit RewardDistributed(target, amount);
    }

    function _distributeSecondReward(
        address from,
        uint256 amount
    ) internal returns (bool) {
        if (referrals[from].length == 0) {
            return false;
        }

        address[] memory targets = referrals[from];
        for (uint256 i = 0; i < targets.length; i++) {
            _distributeTo(targets[i], amount);
        }

        return true;
    }
}
