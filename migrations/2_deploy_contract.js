var KYCValidatorWithAPICall = artifacts.require("./KYCValidatorWithAPICall.sol");

module.exports = function(deployer, network, accounts) {
    //dev
    deployer.deploy(KYCValidatorWithAPICall,{ from: accounts[0], value: "4000001234" });

    //production
    //deployer.deploy(KYCValidatorWithAPICall);
};