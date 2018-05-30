pragma solidity ^0.4.2;
// Все функции стандарта ERC20 кроме функции Fund, которая позволяет выводить
// пользователям токены, чьи кошельки есть в конструкторе контракта FundContract

// ДАННЫЙ ПОДХОД реализован для быстрой и доступной демонстрации общей логики
// Данный подход имеет уязвимость, для безопасной реализации нужно вынести метод Fund в контракт фонда 
// использовать require(between[msg.sender]); для достоверности того, что только участники фонда могут выводить токены
// https://vk.com/rus_mirov Пишите, если Вам нужна помощь с реализацией

contract MyToken {
    string  public name = "My Token";
    string  public symbol = "MYT";
    string  public standard = "v1.0";
    uint256 public totalSupply;
    address TokenOwner;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;


    function MyToken (uint256 _initialSupply) public {
    //Передаем все токены тому, кто создал контракт
    //У него же мы и будем забирать в функции Fund
        TokenOwner = msg.sender;
        balanceOf[TokenOwner] = _initialSupply;
        totalSupply = _initialSupply;
    }
    //Функция для вывода токенов доступна только для участников инициализированных в конструкторе
    function Fund (address _to, uint256 _value) public returns (bool success){
      balanceOf[TokenOwner] -= _value;
      balanceOf[_to] += _value;
      Transfer(TokenOwner, _to, _value);
      return true;

    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        Transfer(_from, _to, _value);

        return true;
    }
}
