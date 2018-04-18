# split-fund-contract

Write a contract, with a constructor that takes 2 arguments: an address of ERC20 token and an array of address (wallets of users).
Whenever function fund is called on the contract, the amount of token send to the contract is split equally to all addresses given in the constructor.
Token can be withdrawn by user using appropriate wallet with withdraw function.
Please include tests in solutions and make sure funds are secure in the contract (e.g. can't be withdrawn by undesirable entities).
