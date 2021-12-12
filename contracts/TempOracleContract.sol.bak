// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
//import "github/com/provable-things/ethereum-api/provableAPI_0.6.sol";

import "./imported/provableAPI.sol"; 

contract TempOracleContract is usingProvable {
    string public temp;
    uint256 public priceOfUrl;
    constructor() public payable{}
    event logResult(string result); 
    event logPrice(uint256 price);  
    event logQueryId(bytes32 price); 

    function __callback(bytes32 /*myid prevent warning*/, string memory result ) override public {
        emit logResult(result);
        if(msg.sender != provable_cbAddress()) revert();
        temp = result;
    }

    function GetTemp() public payable {
      priceOfUrl = provable_getPrice("URL");
      emit logPrice(priceOfUrl);
      require (address(this).balance >= priceOfUrl, "Please add some ETH to cover the query fee");
      bytes32 queryId = provable_query("URL", "json(https://my-json-server.typicode.com/cuteberry/demo/0x9f0e2042ee058F43aB6b3Ee99287fc61153641aB).hasKYC", 20000);
      emit logQueryId(queryId);
    }

}