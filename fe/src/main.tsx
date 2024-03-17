window.global ||= window;
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";
import ReactDOM from "react-dom/client";
import { WagmiProvider } from "wagmi";
import { config } from "./network/wagmi.ts";
import { Buffer } from "buffer";
import App from "./App.tsx";
import { NextUIProvider } from "@nextui-org/react";
import { DBConfig } from "./utils/dbconfig.ts";
import { initDB } from "react-indexed-db-hook";
import "./index.css";

globalThis.Buffer = Buffer;

const queryClient = new QueryClient();

initDB(DBConfig);

// biome-ignore lint/style/noNonNullAssertion: <explanation>
ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <NextUIProvider>
          <App />
        </NextUIProvider>
      </QueryClientProvider>
    </WagmiProvider>
  </React.StrictMode>
);
