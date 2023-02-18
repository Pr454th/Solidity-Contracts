//solidity

pragma solidity ^0.8.17;

contract myContract{
    //owner dad
    //persists data will stay on contract
    address owner;
    event LogKidsFunding(address addr,uint amount,uint balance);

    constructor(){
        owner=msg.sender;
    }
    //define kid
    //memory
    struct kid{
        address payable walletAddress;
        string firstname;
        string lastname;
        uint releaseTime;
        uint amount;
        bool canwithdraw;
    }

    kid[] public kids;

    modifier onlyOwner(){
        require(msg.sender==owner,"only owner can add kids");
        _;
    }

    //add kid to contract
    function addKid(
        address payable walletAddress,
        string memory firstname,
        string memory lastname,
        uint releaseTime,
        uint amount,
        bool canwithdraw) public onlyOwner{
            kids.push(kid(
                walletAddress,
                firstname,
                lastname,
                releaseTime,
                amount,
                canwithdraw
            ));
        }
    //functions
    //view balance
    //pure restricts you to access contract members
    function balanceOf() public view returns(uint){
        return address(this).balance;
    }

    //deposit funds to contract specific to kid's account

    function deposit(address walletAddress) payable public{
        addToKidsBalance(walletAddress);
    }
    function addToKidsBalance(address walletAddress) private {
        for(uint i=0;i<kids.length;i++){
            if(kids[i].walletAddress==walletAddress){
                kids[i].amount+=msg.value;
                emit LogKidsFunding(walletAddress,msg.value,balanceOf());
            }
        }
    }

    function getIndex(address walletAddress) view private returns(uint){
        for(uint i=0;i<kids.length;i++){
            if(kids[i].walletAddress==walletAddress){
                return i;
            }
        }
        return 99;
    }
    //kids checks if able to withdraw
    function avaliableToWithdraw(address walletAddress) public returns(bool){
        uint index=getIndex(walletAddress);
        require(block.timestamp>kids[index].releaseTime,"you are not ready to withdraw");
        if(block.timestamp>kids[index].releaseTime)
        {
            kids[index].canwithdraw=true;
            return true;
        }
        return false;
    }


    //withdraw money
    function withdraw(address payable walletAddress) payable public{
        uint index=getIndex(walletAddress);
        require(msg.sender==kids[index].walletAddress,"you are not the rightful kid to withdraw");
        require(kids[index].canwithdraw==true,"you are not able to withdraw at this time");
        kids[index].walletAddress.transfer(kids[index].amount);
    }
}
    // uint amount;//non negative integer
    // bool isTotal;//booolean
    // string 'hello'//string
    // address walletAddress;//address