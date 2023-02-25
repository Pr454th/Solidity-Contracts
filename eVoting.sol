pragma solidity ^0.8.17;

contract voting{
    address public owner;
    address[] public candidateList;
    mapping(address=>uint8) public votesReceived;
    
    enum votingStatus {NotStarted,Running,Completed}
    votingStatus public status;

    //voting winner
    address public winner;
    uint public winnerVotes;

    constructor() public{
        owner=msg.sender;
    }
    modifier OnlyOwner{
        if(msg.sender==owner){
            _;
        }
    }
    //status setting
    function setStatus() OnlyOwner public{
        if(status!=votingStatus.Completed && status!=votingStatus.Running) status=votingStatus.Running;
        else status=votingStatus.Completed;
    }

    //registering candidate
    function registerCandidates(address _candidate) public OnlyOwner{
        candidateList.push(_candidate);
    }

    //voting
    function vote(address _candidate) public{
        require(validateCandidate(_candidate),"Not a valid candidate!");
        require(status==votingStatus.Running,"Election is not running/active");
        votesReceived[_candidate]=votesReceived[_candidate]+1;
    }

    //validating vote
    function validateCandidate(address _candidate) view public returns(bool){
        for(uint i=0;i<candidateList.length;i++){
            if(candidateList[i]==_candidate){
                return true;
            }
        }
        return false;
    }

    //votesCount of candidate
    function getVoteCountCandidate(address _candidate) public view returns(uint){
        require(validateCandidate(_candidate),"Not a participant");
        require(status==votingStatus.Running,"Election is not running/active");
        return votesReceived[_candidate];
    }

    //result
    function result() public{
        require(status==votingStatus.Completed,"Voting is not Completed, Result can't be declared!");
        for(uint i=0;i<candidateList.length;i++){
            if(votesReceived[candidateList[i]]>winnerVotes){
                winnerVotes=votesReceived[candidateList[i]];
                winner=candidateList[i];
            }
        }
    }
}
