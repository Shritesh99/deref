// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import ERC20 interface
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Import ZK-SNARK verifier contract interface
import "./ZkProofVerifier.sol";

contract ReferralSystem {
    // Define ERC20 token contract address
    address public tokenAddress;

    // Mapping to track referrers and their referrals
    mapping(address => address[]) public referrals;

    // Mapping to track rewards earned by referrers
    mapping(address => uint256) public rewards;

    // Mapping to store unique referral codes for each user
    mapping(address => bytes32) public referralCodes;

    // ZK-SNARK verifier contract address
    address public zkVerifierAddress;

    // Events to emit upon referral, reward distribution, and code generation
    event Referral(address indexed referrer, address indexed referee);
    event RewardDistributed(address indexed referrer, uint256 amount);
    event ReferralCodeGenerated(address indexed user, bytes32 referralCode);

    // Constructor to set the ERC20 token address and ZK-SNARK verifier address
    constructor(address _tokenAddress, address _zkVerifierAddress) {
        tokenAddress = _tokenAddress;
        zkVerifierAddress = _zkVerifierAddress;
    }

    // // Function to generate a unique referral code for a user using a ZK proof
    // function generateReferralCode(bytes32 _publicInput, uint256[] memory _proof) external {
    //     require(referralCodes[msg.sender] == bytes32(0), "Referral code already generated");

    //     // Verify the ZK proof using the ZK-SNARK verifier contract
    //     require(ZkProofVerifier(zkVerifierAddress).verifyProof(_publicInput, _proof), "ZK proof verification failed");

    //     bytes32 code = keccak256(abi.encodePacked(msg.sender, _publicInput));
    //     referralCodes[msg.sender] = code;
    //     emit ReferralCodeGenerated(msg.sender, code);
    // }

    //TODO: zk based proof here
    // Function to refer new users using a referral code
    function referWithCode(bytes32 _referralCode) external {
        require(referralCodes[msg.sender] == _referralCode, "Invalid referral code");
        address referrer = address(bytes20(_referralCode));
        referrals[referrer].push(msg.sender);
        emit Referral(referrer, msg.sender);

        // Distribute rewards to referrers (up to three levels)
        distributeRewards(referrer, 3);
    }

    // Function to distribute rewards to referrers recursively
    function distributeRewards(address _referrer, uint256 _levels) internal {
        // Base case: stop if reached maximum referral levels or referrer has no referrals
        if (_levels == 0 || referrals[_referrer].length == 0) {
            return;
        }

        // Calculate reward for the referrer (for demonstration purposes, let's say 100 tokens per level)
        uint256 rewardAmount = 100 * _levels;

        // Distribute reward to the referrer
        IERC20(tokenAddress).transfer(_referrer, rewardAmount);
        rewards[_referrer] += rewardAmount;
        emit RewardDistributed(_referrer, rewardAmount);

        // Distribute rewards to the referrer's referrals recursively
        for (uint256 i = 0; i < referrals[_referrer].length; i++) {
            distributeRewards(referrals[_referrer][i], _levels - 1);
        }
    }

    // Function to retrieve total rewards earned by a referrer
    function getTotalRewards(address _referrer) external view returns (uint256) {
        return rewards[_referrer];
    }
}