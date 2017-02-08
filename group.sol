pragma solidity ^0.4.0;

import "assess/user.sol";
import "assess/userRegistry.sol";

contract Group
{
  uint public size;
  uint public stake;
  bytes32 public goal;
  address[] public members;
  address[] public requirements;
  address concept;
  address registry;
  address userRegistry;
  mapping (address => Member) memberData;
  enum State {
    Init,
    Done
  }
  State state; //1 = started,

  struct Member {
    mapping (address => bool) votes;
    address finalAssessment;
    bool done;
  }

  modifier onlyRegistry()
  {
    if (msg.sender != registry)
    {
      throw;
    }
    _;
  }

  modifier onlyThis()
  {
    if(msg.sender != address(this))
    {
      throw;
    }
    _;
  }

  function Group(address _concept, uint _size, uint _stake, address[] _requirements, address _userRegistry)
  {
    concept = _concept;
    registry = msg.sender;
    userRegistry = _userRegistry;
    requirements = _requirements;
    addMember(msg.sender);
    size = _size;
    stake = _stake;
    state = State.Init;
  }

  function addMember(address member) returns(bool)
  {
    if(members.length >= size)
    {
      return false;
    }

    for (uint i = 0; i <= requirements.length; i++)
    {
      if(User(member).conceptPassed(requirements[i]) == false)
      {
        return false;
      }
    }

    if (getStake(member, stake) != true)
    {
      return false;
    }

    members.push(member);
    return true;
  }

  function setDone()
  {
    memberData[msg.sender].done = true;
    for(uint i = 0; i <= members.length; i++)
    {
      if(memberData[members[i]].done == false)
      {
        return;
      }
    }
    state = State.Done;
  }

  //function startFinalAssessment(address member) onlyThis{
    //memberData[member].finalAssessment = makeAssessment(member, concept, );
    //if(memberData[member].finalAssessment != true){
      //return;
    //}
  //}

  function makeAssessment(address _member, address _concept, uint _time, uint _size) onlyThis returns(bool)
  {
    return User(_member).extMakeAssessment(_concept, _time, _size);
  }

  function getStake(address user, uint value) onlyThis returns(bool)
  {
    return User(user).extTransferTokens(address(this), value);
  }

  function returnStake(address user)
  {
    if(state == State.Done){
      //UserRegistry(us)
    }
  }
  function kick(address member) {
    memberData[member].votes[msg.sender] = true;
    for(uint i=0; i < members.length; i++)
    {
      if(!memberData[member].votes[members[i]])
      {
        return;
      }
    }
    //The process for kicking out a member goes here


  }
}
