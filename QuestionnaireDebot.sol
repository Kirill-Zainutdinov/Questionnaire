pragma ton-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

import "libraries/Debot.sol";
import "interfaces/Terminal.sol";
import "interfaces/IQuestionnaire.sol";

contract HelloDebot is Debot {

    address public qAddress;
    string name_;
    string age;

    constructor(address _qAddress) public{
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        qAddress = _qAddress;
    }

    function setQAddress(address _qAddress) public {
        tvm.accept();
        qAddress = _qAddress;
    }

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string caption, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Questionnaire";
        version = "0.1.0";
        publisher = "MSHP";
        caption = "Student survey";
        author = "Kirill Zaynutdinov";
        support = address.makeAddrStd(0, 0x0);
        hello = "Hello, i am a Questionnaire DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = "";
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID ];
    }

    function start() public override {
        Terminal.input(tvm.functionId(dSetName), "What is your name?", false);
    }

    function dSetName(string value) public view{
        optional(uint256) pubkey = 0;
        IQuestionnaire(qAddress).setName
        {
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(dInputAge),
            onErrorId: tvm.functionId(onError)
        }(value).extMsg;
    }

    function dInputAge() public view{
        Terminal.input(tvm.functionId(dSetAge), "how old are you?", false);
    }

    function dSetAge(string value) public view{
        optional(uint256) pubkey = 0;
        IQuestionnaire(qAddress).setAge
        {
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(dInputSchool),
            onErrorId: tvm.functionId(onError)
        }(value).extMsg;
    }

    function dInputSchool() public view{
        Terminal.input(tvm.functionId(dSetSchool), "What school are you in?", false);
    }

    function dSetSchool(string value) public view{
        optional(uint256) pubkey = 0;
        IQuestionnaire(qAddress).setSchool
        {
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(dGetName),
            onErrorId: tvm.functionId(onError)
        }(value).extMsg;
    }

    function dGetName() public view{
        optional(uint256) none;
        IQuestionnaire(qAddress).name
        {
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(dGetAge),
            onErrorId: tvm.functionId(onError)
        }().extMsg;
    }

    function dGetAge(string _name) public {
        name_ = _name;
        optional(uint256) none;
        IQuestionnaire(qAddress).age
        {
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(dGetSchool),
            onErrorId: tvm.functionId(onError)
        }().extMsg;
    }

    function dGetSchool(string _age) public {
        age = _age;
        optional(uint256) none;
        IQuestionnaire(qAddress).school
        {
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(greeting),
            onErrorId: tvm.functionId(onError)
        }().extMsg;
    }

    function greeting(string _school)public{
        Terminal.print(0, format("Hello {} year old {} from school {}!", age, name_, _school));
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
    }
}
// deployed in devnet 0:44f01ba72ec8cbd7cbf082e0dee66a155d31c078d7ac59d26280813a6f21576f