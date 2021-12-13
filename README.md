# KYC Validaor Project

## Table of Contents

## Use cases
-  We can retrived user's KYC data off chain and store it in the smart contract. We can periodically refresh this data. 
-  Other smart contract can call this contract to check the user's current KYC status. 

## Mechanics
-  Truffle - used to build and deploy the smart contract. 
-  web3-React - used to conect smart contract with React UI.  
-  Chainlink - used to call off chain API. 
-  Infuar - used to deploy ontract on chain 

## Folder structure
```
KYCValidator
|── client
|    └── public
|    └── src
|           └── components
|           └── contracts
|           └── hooks
|           └── pages
|           └── static
|           └── styles
|           └── utils
|── contracts
|── docs
|── migrations
|── test
```

## Deployment
```
npm install 
npm install @chainlink/contracts
truffle compile
truffle deploy --reset  --network kovan
```

## Test Command
- Local test
    - run `truffle test` with ganche-cli on port 8545
- live test
```
cd client
yarn
yarn start
```

## Testing Instructions
- Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8
- JobId: 7401f318127148a894c00c292e486ffd
- targetAddress: https://github.com/cuteberry/demo/blob/master/db.json
- Make sure there is enough ETH and LINK in the contract 
    - Use [this link](https://faucets.chain.link/kovan?_ga=2.177983335.312954236.1639262171-26356466.1633074752) to fund deployed contract address with LINK and ETH on Kovan
    - Check smart contract account balance [here](https://kovan.etherscan.io/address/0x5d97A2DD17517379010b6f7FaC1aE7B5c963F91d)
- During MetaMask testing: make sure increase the Max Fee for the transation to allow it to pass through fast. 
- Sample KYC data is hosted at this link https://my-json-server.typicode.com/cuteberry/demo/{address}
- The editable version is at https://github.com/cuteberry/demo/blob/master/db.json. 

## Author's public ethereum account
Mei Lazell
0x520A74215410c7832911bb0c7b86c6c353BBd08C

## [Screen cast of this project](https://drive.google.com/file/d/1Ybf1BwYI7m-k5CzN9RK9Y5R8k3TLhcuU/view?usp=sharing)

## Public Deployed Frontend Site Using Netlify
[https://musing-leavitt-df2f94.netlify.app/](https://musing-leavitt-df2f94.netlify.app/)





