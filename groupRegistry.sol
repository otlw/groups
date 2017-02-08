pragma solidity ^0.4.0;

import 'assess/user.sol';
import 'assess/userRegistry.sol';
import 'group.sol';

contract GroupRegistry
{
  mapping (address => address[]) public groups;
  mapping (address => address) public conceptFromGroup;
  address userRegistryAddress;

  modifier onlyUser()
  {
    if(UserRegistry(userRegistryAddress).balances(msg.sender) <= 0)
    {
      throw;
    }
    _;
  }

  function GroupRegistry(address _userRegistryAddress)
  {
    userRegistryAddress = _userRegistryAddress;
  }


  function addGroup(address concept, uint size, uint stake, address[] requirements) onlyUser
  {
    Group newGroup = new Group(concept, size, stake, requirements, userRegistryAddress);
    groups[concept].push(address(newGroup));
    conceptFromGroup[address(newGroup)] = concept;
  }
}
