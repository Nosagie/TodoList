// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "@nomiclabs/buidler/console.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ToDos {

  using SafeMath for uint256;
  IERC20 token;

  event SetPurpose(address sender, string purpose);
  event TaskCreated(address owner,address assingnee,string pay_token);

  string public purpose = "🛠 Programming Unstoppable Money";

  struct Task {
    bytes32 ID;
    string payToken;
    string description;
    address payable assigner;
    address payable assignee;
    address token_address;
    uint256 pay_amount;
    bool completed;
  }
  Task[] public tasks;

  function createETHTask(string calldata desc_,address payable assignee_) external payable
  {
    require(msg.value > 0,"Payment should be greater than 0");
    bytes32 taskId = keccak256(abi.encodePacked(desc_, msg.sender, assignee_,block.timestamp,msg.value));
    tasks.push(Task(taskId,"ETH",desc_,msg.sender,assignee_,address(0),msg.value,false));
    emit TaskCreated(msg.sender,assignee_,"ETH");
  }

  function createTokenTask(string calldata desc_,address payable assignee_,address token_addr_,uint256 amount_) 
    external payable
  {
      require(amount_ > 0,"Payment should be greater than 0");
      token = IERC20(token_addr_);
      require(token.transferFrom(msg.sender,address(this),amount_),"Error transferring, is it approved?");
      bytes32 taskId = keccak256(abi.encodePacked(desc_, msg.sender, assignee_,block.timestamp,amount_));
      tasks.push(Task(taskId,token.name(),desc_,msg.sender,assignee_,token_addr_,amount_,false));
      emit TaskCreated(msg.sender,assignee_,token.name());
  }

  function markCompleted(bytes32 taskID_) external  returns (bool)
  {
    for(uint i = 0; i < tasks.length;i++){
        if (tasks[i].ID == taskID_){
          Task storage toMark = tasks[i];
          require(toMark.assigner == msg.sender,"Not your task");
          // transfer funds to assignee
          if (toMark.token_address == address(0)) //ETH market
          {
            (bool sent,) = (toMark.assignee).call{value:toMark.pay_amount}("");
            require(sent,"ETH not sent");
          }
          else
          {
            token = IERC20(toMark.token_address);
            require(token.transfer(toMark.assignee,toMark.pay_amount),"Issue with Token Transfer");
          }
          toMark.completed = true;
          return true;
        }
    }
    return false;
  }

  function setPurpose(string memory newPurpose) public {
    purpose = newPurpose;
    console.log(msg.sender,"set purpose to",purpose);
    emit SetPurpose(msg.sender, purpose);
  }

  function getAllTasks() external view returns(Task[] memory)
  {
    return tasks;
  }

}
