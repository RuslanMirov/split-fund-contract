pragma solidity ^0.4.2;

// Импорт ERC20
import "./MyToken.sol";

contract FundContract {

//Переменная контракта ERC20
  MyToken public tokenContract;
// Мапинг для фиксирования чтобы один участник не мог выводит с фонда больше дозволенного
  mapping(address => uint) public amountsWithdrew;
//Вспомогательный мапинг для записи пользователей, которые могут делить средства из фонда
  mapping(address => bool) public between;
// Общая сумма токенов, внесенных в фонд.
  uint public totalInput;
// Количество кошельков, которые могут делить токены
  uint public count;

  //Конструктор принимает в параметрах адресс контракта и массив кошельков
  function FundContract(MyToken _tokenContract, address[] _addresses) public {
// Получаем количество токенов из ERC20  контракта
  totalInput = _tokenContract.totalSupply();
// Количество пользователей фонда
  count = _addresses.length;
// Инициализируем адресс контракта ERC20
  tokenContract = _tokenContract;

// Записываем кошельки пользователей фонда
  for (uint i = 0; i < _addresses.length; i++) {
  address included = _addresses[i];
  between[included] = true;
  }
  }

//Реализация функции transfer из ERC20
  function transferFunction (address addr, uint amount) public{
  tokenContract.transfer(addr, amount);
  }


// Вывод средств из фонда
// Доступно только кошельков инициализированных в контракте
  function FundWindraw() public returns (bool s){
// Только для участников фонда
  require(between[msg.sender]);

// Получаем сумму из функции balance() которую можно выввести 
  uint transferring = FundContract.balance();
  require(transferring != 0);
// Записываем сумму которую пользователь вывел, чтобы он не смог вывести больше 
  amountsWithdrew[msg.sender] += transferring;
// Транзакция
  tokenContract.Fund(msg.sender, transferring);
// В случае успеха возвращем true для тестов
  return true;
  }

  function balance() constant returns (uint) {
    if (!between[msg.sender]) {
// Функция работает только с теми кто включен в список
// Для остальных возвращаем 0
    return 0;
    }
// Делим сумму на количество
// отнимаем сумму которую вывели от дозволенной суммы, чтобы пользователь не вывел больше положенного

    uint share = totalInput / count;
    uint withdrew = amountsWithdrew[msg.sender];
    uint available = share - withdrew;

    assert(available >= 0 && available <= share);

    return available;
    }

// Фолбэк функция
   function() payable {
    totalInput += msg.value;
  }
}
