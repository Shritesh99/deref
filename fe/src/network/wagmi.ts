import { baseSepolia, sepolia } from "wagmi/chains";
import { defaultWagmiConfig } from "@web3modal/wagmi/react/config";
import { createWeb3Modal } from "@web3modal/wagmi/react";

const metadata = {
  name: "DeRef",
  description: "DeRef",
  url: "http://127.0.0.1", // origin must match your domain & subdomain
  icons: ["https://avatars.githubusercontent.com/u/37784886"],
};

const chains = [sepolia, baseSepolia] as const;
const config = defaultWagmiConfig({
  chains,
  projectId: import.meta.env.VITE_WC_PROJECT_ID!,
  metadata,
});

createWeb3Modal({
  wagmiConfig: config,
  projectId: import.meta.env.VITE_WC_PROJECT_ID!,
  enableAnalytics: true, // Optional - defaults to your Cloud configuration
  enableOnramp: true, // Optional - false as default
});

export { config };
