//SPDX-Licensed-Identifier: MIT
// SPDX-License-Identifier: UNLICENSED
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Detailed.sol";
pragma solidity 0.6.12;

/*interface IERC20 {

    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}*/


contract RenewItToken is ERC20 {
    address owner;
    constructor () ERC20("RenewToken", "REN") public {
       _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }
    
}
     
    
   
