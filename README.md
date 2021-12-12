# KYC Validaor Project

## Table of Contents

# Verify an account's KYC status
Sample KYC data is hosted at this link https://my-json-server.typicode.com/cuteberry/demo/{address}
The editable version is at https://github.com/cuteberry/demo/blob/master/db.json. 

## Use case s
1. We can retrived user's KYC data off chain and store it in the smart contract. We can periodically refresh this data. 
2. Other smart contract can call this contract to check the user's current KYC status. 

## Mechanics
Truffle - used to build and deploy the smart contract
web3-React - used to conect smart contract with React UI. 
Chainlink - used to call off chain API 

## Test
run `truffle test` with ganche-cli on port 8545

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
## Install dependencies
`npm install`

## Deployment
npm install @chainlink/contracts
truffle compile
truffle deploy --reset  --network kovan

## Testing guidance
Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8
JobId: 7401f318127148a894c00c292e486ffd
targetAddress: https://github.com/cuteberry/demo/blob/master/db.json
Use this link to fund deployed contract address with LINK and ETH on Kovan
https://faucets.chain.link/kovan?_ga=2.177983335.312954236.1639262171-26356466.1633074752

## Author's public ethereum account
Mei Lazell
0x520A74215410c7832911bb0c7b86c6c353BBd08C

## [Screen cast of final project](https://drive.google.com/file/d/116_89AJQnns5Jth5AYIigYG79U8ycLLA/view?usp=sharing)

## Public Deployed Frontend Site Using Netlify
[https://musing-leavitt-df2f94.netlify.app/](https://musing-leavitt-df2f94.netlify.app/)





