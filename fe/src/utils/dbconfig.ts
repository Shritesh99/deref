export const DBConfig = {
    name: "DeRefDB",
    version: 2,
    objectStoresMeta: [
      {
        store: "worldcoin",
        storeConfig: { keyPath: "id", autoIncrement: true },
        storeSchema: [
          { name: "proof", keypath: "proof", options: { unique: false } },
          { name: "merkle_root", keypath: "merkle_root", options: { unique: false } },
          { name: "nullifier_hash", keypath: "nullifier_hash", options: { unique: false } },
        ],
      },
      {
        store: "referrals",
        storeConfig: { keyPath: "id", autoIncrement: true },
        storeSchema: [
          { name: "code", keypath: "code", options: { unique: false } },
        ],
      },
    ],
  };