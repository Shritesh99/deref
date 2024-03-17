# DeRef 

DeRef is a decentralized referral system built on the Base testnet that utilizes zero-knowledge proofs to enable private and secure referrals. 
The system allows users to invite referrers, and track referral rewards while maintaining the privacy of both the referrer and the referred party.


## PROJECT DESCRIPTION: User Journey

### Step 1: Account Creation (WorldID)
Users access the DeRef platform and create an account. Users need to already have a WorldID dApp logged with a WorldID account

### Step 2: Wallet Connection
Users access the DeRef platform and connect their preferred wallet (e.g., Metamask, Wallet Connect) to their DeRef account. The platform supports multiple wallet options for user convenience

### Step 3: Profile Verification
Users verify their profile using World ID, a decentralized identity verification system
They scan the World ID code and receive a confirmation message upon successful verification

### Step 4: Referral Actions
Users can choose between two actions: generating a referral code or using an existing referral code
If generating a referral code, users click on the "New Referral Code" button

### Step 5: Referral Code Generation
Upon clicking "New Referral Code," users receive a unique invite link 
The invite link can be easily copied and shared on various web2 social media

### Step 6: Referral Rewards
Users earn rewards when their referred individuals successfully refer others
The referral chain continues up to a maximum of 3 referrals per user
Users receive their rewards once the referral conditions are met (i.e. their referred individuals have made certain purchases)

### Step 7: Using a Referral Code
If users choose to use an existing referral code, they click on the "Use Referral Code" button
The user copies the referral link provided by their referee
The user can share this referral link with a maximum of 3 other users

### Step 8: Automatic Referral Rewards
When a referred user joins the platform using the shared referral link, they automatically receive a payment in the form of a token directly in their connected wallet. This royalty system incentivizes users to join the platform and encourages them to refer others

### Step 9: Referral Chain Perpetuation
Each newly onboarded user has the potential to refer a maximum of 3 friends, continuing the referral chain
As new users join through referral links, they also receive the token reward in their wallet
This creates a self-perpetuating referral system that incentivizes user growth and engagement

## How it's Made

The project consists of three main components: 

### WorldID:

- Integrate Sign in with World ID or Incognito Actions.
- World ID must be fully integrated. Proof validation is required and needs to occur in a web backend or smart contract.

### 1. Referral Invitation:
   - Referrers can invite others to join the referral campaign by generating unique referral codes using a zero-knowledge proof system or an ENS domain.
   - If users wish to protect their identity, the referral codes are generated using ZK-proofs, a cryptographic method that preserves the privacy of both the referrer and the referred party. If the users want to keep the referral public, they can use the ENS domain.
   - The referral codes are stored onchain in hashes.

### 2. Referral Tracking:
   - When a referred party joins the platform or makes a purchase using a referral code, if users want to mantain their privacy, the system verifies the possession of the code using ZK-proofs. The verification process ensures that the referral is legitimate without revealing the identities of the involved parties.
   - Upon successful verification, the referral rewards are credited to the referrer's account on the blockchain.

### 3. Referral Rewards Distribution:
   - The referral rewards are automatically distributed to the referrers based on a predefined royalty structure.
   - The distribution of rewards is triggered by smart contracts on the blockchain, ensuring transparency and immutability.



