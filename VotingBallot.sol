pragma solidity 0.6.6;

contract Votingballot{
    address public goverment;//The goverment is the one who is startting the voting
    //Lets assume that we have two party
    uint count_party1;
    uint count_party2;
    //Here the voting is completely decentralsied the owner is for to just see the  counts of parties
    modifier owner() {
        require(msg.sender == goverment);
        _;
    }
    //We here first want our regestrationn to complete 
    uint public deadline_for_regestration;
    //After the regestration we want our voting to start
    uint public dedaline_for_voting;
    //Here is the construtor whihc takes the time for regestration and voting and its the goverment who deploys the contract
    constructor(uint _deadline_for_regestration,uint _deadline_for_voting) public{
        deadline_for_regestration = block.timestamp + _deadline_for_regestration;
        dedaline_for_voting = block.timestamp+deadline_for_regestration+ _deadline_for_voting;
      
        goverment = msg.sender;
    }

    
    //Lets take some information about the voter
    struct people{
        uint  age;
        string name;
        address person_address;
        bool voted;
        // we mapped the address of voter to the boolean to check weather the person voted or not
        mapping(address => bool) votedornot;
       

    }
    //here we mapped uint with the structure containg information at that index
   mapping(uint => people) public data;
    uint track;
    //Here we take the information that people
    function takingpeopleinfo(uint _age,string memory _name,address _personaddres) public{
        require(block.timestamp < deadline_for_regestration);
        people storage newdata = data[track];
        track++;//Increamenting at every index
        newdata.age = _age;
        
        newdata.name = _name;
        newdata.person_address = _personaddres;

    }
    //Here we allow voter to vote 
    function voteforparty1(uint __track) public returns(uint){
        require(deadline_for_regestration<dedaline_for_voting);
       track = __track;
       people storage newdata = data[track];
       require(newdata.person_address == msg.sender && newdata.age>=18 && newdata.votedornot[msg.sender]==false);
       newdata.votedornot[msg.sender] = true;
       count_party1++;
       return count_party1;
      

    }
    function voteforparty2(uint __track) public returns(uint){
        require(deadline_for_regestration<dedaline_for_voting);
        track = __track;
       people storage newdata = data[track];
       require(newdata.person_address == msg.sender && newdata.age>=18 && newdata.votedornot[msg.sender]==false);
       newdata.votedornot[msg.sender] = true;
       count_party2++;
       return count_party2;

    }
    //here after the voting is completed we check the votes
    function countvoters() owner() public returns(uint)  {
        require(block.timestamp > dedaline_for_voting);
        return count_party1;
    }
    function countvotersforpart2() public returns(uint){
        require(block.timestamp > dedaline_for_voting);
        return count_party2;
    }
}