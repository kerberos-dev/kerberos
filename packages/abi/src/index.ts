export const portfolioFactoryAbi = [
  {
    type: "function",
    name: "createPortfolio",
    stateMutability: "nonpayable",
    inputs: [
      {
        name: "metadata",
        type: "tuple",
        components: [
          { name: "name", type: "string" },
          { name: "symbol", type: "string" },
          { name: "strategyURI", type: "string" },
          { name: "asset", type: "address" },
          { name: "manager", type: "address" }
        ]
      }
    ],
    outputs: [
      { name: "vault", type: "address" },
      { name: "share", type: "address" }
    ]
  },
  {
    type: "event",
    name: "PortfolioCreated",
    inputs: [
      { name: "manager", type: "address", indexed: true },
      { name: "asset", type: "address", indexed: true },
      { name: "vault", type: "address", indexed: false },
      { name: "share", type: "address", indexed: false },
      { name: "name", type: "string", indexed: false },
      { name: "symbol", type: "string", indexed: false },
      { name: "strategyURI", type: "string", indexed: false }
    ]
  }
] as const;

export const portfolioVaultAbi = [
  {
    type: "function",
    name: "addLiquidity",
    stateMutability: "nonpayable",
    inputs: [{ name: "assets", type: "uint256" }],
    outputs: [{ name: "shares", type: "uint256" }]
  },
  {
    type: "function",
    name: "removeLiquidity",
    stateMutability: "nonpayable",
    inputs: [{ name: "shares_", type: "uint256" }],
    outputs: [{ name: "assets", type: "uint256" }]
  }
] as const;

export const marketRouterAbi = [
  {
    type: "function",
    name: "route",
    stateMutability: "nonpayable",
    inputs: [
      { name: "adapter", type: "address" },
      { name: "adapterData", type: "bytes" },
      { name: "expectedActionHash", type: "bytes32" },
      { name: "sourceId", type: "bytes32" }
    ],
    outputs: [{ name: "result", type: "bytes" }]
  }
] as const;
