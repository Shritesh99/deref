// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ByteHasher} from "./WorldIDHelpers/ByteHasher.sol";
import {IWorldID} from "./WorldIDHelpers/IWorldID.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ReferralSystem {
    using ByteHasher for bytes;

    uint256 constant REWARD_AMOUNT = 100;
    uint256 constant SECOND_REWARD_AMOUNT = 30;

    error InvalidNullifier();

    // World ID Verification
    IWorldID internal immutable worldId;
    uint256 internal immutable externalNullifier;
    uint256 internal immutable groupId = 1;

    // Define ERC20 token contract address
    address public tokenAddress;

    // referral
    mapping(uint256 => uint256[]) public referrals;
    mapping(uint256 => mapping(uint256 => bool)) refered;
    mapping(uint256 => uint256) public rewards;

    // Events
    event Referral(uint256 indexed referrer, uint256 indexed referee);
    event RewardDistributed(uint256 indexed referrer, uint256 amount);
    event RewardWithdrew(address indexed account, uint256 amount);

    // Constructor to set the ERC20 token address and ZK-SNARK verifier address
    constructor(
        address _tokenAddress,
        IWorldID _worldId,
        string memory _appId,
        string memory _actionId
    ) {
        tokenAddress = _tokenAddress;
        worldId = _worldId;
        externalNullifier = abi
            .encodePacked(abi.encodePacked(_appId).hashToField(), _actionId)
            .hashToField();
    }

    // Function to retrieve total rewards earned by a referrer
    function getTotalRewards(
        uint256 nullifierHash
    ) external view returns (uint256) {
        return rewards[nullifierHash];
    }

    function withdraw(
        address signal, // recipient
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) external {
        worldId.verifyProof(
            root,
            groupId,
            abi.encodePacked(signal).hashToField(),
            nullifierHash,
            externalNullifier,
            proof
        );

        uint256 amount = rewards[nullifierHash];
        rewards[nullifierHash] = 0;
        IERC20(tokenAddress).transfer(signal, amount);

        emit RewardWithdrew(signal, amount);
    }

    function refer(
        uint256 signal, // referrer
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) external {
        uint256 referrer = signal;

        require(refered[nullifierHash][referrer] == false, "refered already");
        worldId.verifyProof(
            root,
            groupId,
            abi.encodePacked(signal).hashToField(),
            nullifierHash,
            externalNullifier,
            proof
        );

        refered[nullifierHash][referrer] = true;

        // first reward
        _distributeTo(referrer, REWARD_AMOUNT);

        // second reward
        bool isSuccess = _distributeSecondReward(
            referrer,
            SECOND_REWARD_AMOUNT
        );

        // reward for myself
        if (isSuccess) {
            _distributeTo(nullifierHash, REWARD_AMOUNT - SECOND_REWARD_AMOUNT); // +70 to myself
        } else {
            _distributeTo(nullifierHash, REWARD_AMOUNT); // +100 to myself
        }

        referrals[nullifierHash].push(referrer);
    }

    function _distributeTo(uint256 target, uint256 amount) internal {
        rewards[target] += amount;
        emit RewardDistributed(target, amount);
    }

    function _distributeSecondReward(
        uint256 from,
        uint256 amount
    ) internal returns (bool) {
        if (referrals[from].length == 0) {
            return false;
        }

        uint256[] memory targets = referrals[from];
        for (uint256 i = 0; i < targets.length; i++) {
            _distributeTo(targets[i], amount);
        }

        return true;
    }
}
