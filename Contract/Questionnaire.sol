pragma ton-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

contract Questionnaire{

    string public name;
    string public age;
    string public school;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function setName(string _name)external{
        tvm.accept();
        name = _name;
    }

    function setAge(string _age)external{
        tvm.accept();
        age = _age;
    }

    function setSchool(string _school)external{
        tvm.accept();
        school = _school;
    }
}
// deployed in devnet 0:b9cb069e156f0558d79331481ce8a0b2f761bffb87f055c069faf2879cfade30
