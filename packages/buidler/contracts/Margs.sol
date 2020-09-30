// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Margs is ERC20 {
  constructor() ERC20("Margs","🎈") public {
      _mint(0xD041088bD704Cb7E7ca558E1f3C9593eF8673607,1000*10**18);
  }
}