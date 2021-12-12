var KYCValidatorChainlink = artifacts.require("./KYCValidatorChainlink.sol");

module.exports = function(deployer, network, accounts) {
    //dev
    deployer.deploy(KYCValidatorChainlink,{ from: accounts[0], value: "4000001234" });
};