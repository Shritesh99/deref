import { useCallback } from "react";
import { useWriteContract } from "wagmi";
import ContractAbi from "../network/verifierAbi";
import { decodeAbiParameters } from "viem";

const VERIFIER_CONTRACT_ADDRESS = import.meta.env.VITE_CONTRACT_ADDR!;

export const useSendRefer = () => {
  const { writeContractAsync } = useWriteContract({
    mutation: {
      onError: console.log,
    },
  });

  return useCallback(
    (
      // World ID artifacts
      signal: string, // u256 hex
      worldIdProof: {
        merkle_root: string;
        nullifier_hash: string;
        proof: string;
      },
      // Noir zk artifacts
      zkPublicInputs: string[],
      zkProof: string
    ) => {
      return writeContractAsync({
        abi: ContractAbi,
        address: VERIFIER_CONTRACT_ADDRESS as `0x${string}`,
        functionName: "refer",
        args: [
          signal,
          worldIdProof?.merkle_root,
          worldIdProof?.nullifier_hash,
          decodeAbiParameters(
            [{ type: "uint256[8]" }],
            worldIdProof.proof! as `0x${string}`
          )[0],
          zkPublicInputs,
          zkProof,
        ],
      });
    },
    [writeContractAsync]
  );
};
