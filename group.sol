import ../assess/user.sol

contract Group
{
  uint public size;
  uint public stake;
  bytes32 public goal;
  address[] public members;
  address[] public requirements;
  address concept;
  address registry;
  mapping (address => bool) done;

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

  function Group(address _concept, uint _size, uint _stake, address[] _requirements)
  {
    concept = _concept;
    registry = msg.sender;
    requirements = _requirements;
    addMember(msg.sender);
    size = _size;
    stake = _stake;
  }

  function addMember(address member) returns(bool) 
  {
    if(members.length() >= size)
    {
      return false;
    }

    for (uint i = 0, i <= requirements.length(), i++)
    {
      if(User(member).getConceptPassed(requirements[i]) == false)
      {
        return false;
      }
    }

    if (User(member)).extTransferTokens(address(this), stake) != true)
    {
      return false;
    }
    members.push(member);
    return true;
  }

  function setDone()
  {
    done(msg.sender) = true;
    for(uint i = 0, if i <= members.length(), i++)
    {
      if(done[members[i]] == false)
      {
        return;
      }
    }
    //Call some thing to do if the whole group is done here
  }

  function makeAssessment(address user, address concept, uint time, uint size) onlyThis returns bool
  {
    return User(user).extStartAssessment(concept, time, size);
  }

  function getStake(address user, uint value) {
    return User(user).extTransferTokens(address(this), value);
  }
}
