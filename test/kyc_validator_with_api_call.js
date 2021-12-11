const KYCValidatorWithAPICall = artifacts.require("KYCValidatorWithAPICall");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("KYCValidatorWithAPICall", function (accounts) {
  const [contractOwner, alice, jeff] = accounts;
  const deposit = web3.utils.toBN(2);
  const oneEtherInWei = web3.utils.toBN(1);
  beforeEach(async () => {
    instance = await KYCValidatorWithAPICall.deployed();
    console.log(accounts);
    await instance.send(5, {from: accounts[0]});
  });

  it("is owned by owner", async () => {
    assert.equal(
      await instance.getOwner.call(),
      contractOwner,
      "owner is not correct",
    );
  });
  
  it("should retrieve KYCdata", async () => {
    const kycData = await instance.retrieveKYC(jeff, { from: alice, value: oneEtherInWei});
    console.log(kycData);
    assert.equal(
      kycData,
      "",
      "user doesn't have valid KYC",
    );
  });

  it("should Not have KYC", async () => {
    const kycData = await instance.hasKYC(jeff, { from: alice  });
    console.log(kycData);
    assert.equal(
      kycData,
      "",
      "user has valid KYC",
    );
  });

});
