pragma ton-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

interface IQuestionnaire {
    function setName (string name) external;
    function setAge (string age) external;
    function setSchool (string school) external;
    function name()external returns(string);
    function age()external returns(string);
    function school()external returns(string);
}