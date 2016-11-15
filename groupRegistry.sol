import ../user.sol
import ../userRegistry.sol
import group.sol

contract GroupRegistry
{
  mapping (address => address[]) groups;
  mapping (address => address) conceptFromGroup;
  address userRegistryAddress;

  modifier onlyUser()
  {
    if(userRegistry(userRegistryAddress).getTokenBalance(msg.sender) <= 0)
    {
      throw;
    }
    _;
  }

  function GroupRegistry(address _userRegistryAddress)
  {
    userRegistryAddress = _userRegistryAddress;
  }


  function addGroup(address concept, uint size, address[] _requirements) onlyUser
  {
    Group newGroup = new Group(concept, size, msg.sender);
    groups[concept].push(address(Group));
    conceptFromGroup[address(group)] = concept;
  }
}
