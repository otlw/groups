import "../assess/user.sol";
import "../assess/userRegistry.sol";

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
  int state; //1 = started,

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
    state = 1;
  }

  function addMember(address member) returns(bool)
  {
    if(members.length >= size)
    {
      return false;
    }

    for (uint i = 0; i <= requirements.length; i++)
    {
      if(User(member).getConceptPassed(requirements[i]) == false)
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
    memberData(msg.sender).done = true;
    for(uint i = 0; i <= members.length; i++)
    {
      if(memberData[members[i]].done == false)
      {
        return;
      }
    }
    state = false;
  }

  function startFinalAssessment(address user) onlyThis{
    userData[user].finalAssessment = makeAssessment(user, concept);
    if(userData[user].finalAssessment != true){
      return;
    }
  }

  function makeAssessment(address _user, address _concept, uint _time, uint _size) onlyThis returns(bool)
  {
    return User(_user).extStartAssessment(_concept, _time, _size);
  }

  function getStake(address user, uint value) onlythis returns(bool)
  {
    return User(user).extTransferTokens(address(this), value);
  }

  function returnStake(address user)
  {
    if(!state){
      //UserRegistry(us)
    }
  }
  function kick(address user) {
    memberData[user].votes[msg.sender] = true;
    for(uint i=0; i < members.length; i++)
    {
      if(!memberData[user].votes[members[i]])
      {
        return;
      }
    }
    //The process for kicking out a member goes here


  }
}
