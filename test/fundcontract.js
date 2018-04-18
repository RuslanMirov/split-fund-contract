var FundContract = artifacts.require('./FundContract.sol')

contract('FundContract', function(accounts){
  var fundContractInstance;

  //Инициализация с корректными значениями
  it('initializes the contract with the correct values', function(){
    return FundContract.deployed().then(function(instance){
      fundContractInstance = instance;
      return fundContractInstance.address
    }).then(function(address){
      assert.notEqual(address, 0x0, 'has contract address');
      return fundContractInstance.tokenContract()
    }).then(function(address){
      assert.notEqual(address, 0x0, 'has token contract address');
      return fundContractInstance.count();
    }).then(function(count){
    // Содержит кооректное количество кошельков
    // добавьте сюда больше кошельков, если вы добавите в параметры конструктора больше 2-x
      assert.equal(count, 2, 'Correct number of wallet');
      return fundContractInstance.totalInput();
    }).then(function (totalInput){
      assert.equal(totalInput, 1000000, 'Correct number of tokens');
    });
  });

  // тест на то, чтобы только члены фонда могли выводить токены
  // Укажите акаунт вашей сети в параметрах и потом попробуйте ввести неправильный аккаунт
  it('transfers token only members of fund', function() {
    return FundContract.deployed().then(function(instance) {
      fundContractInstance = instance;
      return fundContractInstance.FundWindraw.call({ from: accounts[5] });
    }).then(function(s) {
      assert.equal(s, true, 'true');

    })
  });
});
