var MyToken = artifacts.require("./MyToken.sol");
var FundContract = artifacts.require("./FundContract.sol");

module.exports = function(deployer) {
  deployer.deploy(MyToken, 1000000).then(function() {

    // В параметрах указать адресса вашей сети
    return deployer.deploy(FundContract, MyToken.address, ["0xf17f52151EbEF6C7334FAD080c5704D77216b732", "0xf17f52151EbEF6C7334FAD080c5704D77216b732"]);
  });
};
