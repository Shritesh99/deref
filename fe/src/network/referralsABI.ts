export const referralsABI = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "signal",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "root",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "nullifierHash",
        type: "uint256",
      },
      {
        internalType: "uint256[8]",
        name: "worldCoinProof",
        type: "uint256[8]",
      },
      {
        internalType: "bytes32[]",
        name: "_publicInputs",
        type: "bytes32[]",
      },
      {
        internalType: "bytes",
        name: "_proof",
        type: "bytes",
      },
    ],
    name: "refer",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;
