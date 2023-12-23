//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Swapping{
    address token1;
    address token2;
    address public owner;

    event Swapped (address user, uint256 amount1, uint256 amount2);
    event WithdrawnToken1 (address user, uint256 amount);
    event WithdrawnToken2 (address user, uint256 amount);

    mapping (address => uint256) amountSwapped;

    constructor (address _token1, address _token2) {
        token1= _token1;
        token2= _token2;
        owner= msg.sender;
    }

    function swap (uint256 _amount1, uint256 _amount2) external {
        require (_amount1 > 0, "cannot swap zero value");
        require (_amount2 > 0, "cannot swap zero value");
        require (IERC20(token1).balanceOf (msg.sender) >= _amount1, "insufficient amount");
        require (IERC20(token2).balanceOf (msg.sender) >= _amount2, "insufficient amount");
        require (_amount1 == _amount2 , "swap amount must be equivalent");

        IERC20(token1).transferFrom(msg.sender, address(this), _amount1);
        IERC20(token1).transferFrom(msg.sender, address(this), _amount2);

        IERC20(token1).transfer(msg.sender, _amount1);
        IERC20(token2).transfer(msg.sender, _amount2);

        amountSwapped[msg.sender] += _amount1;

        emit Swapped (msg.sender, _amount1, _amount2);
    }

    function withdrawToken1 (uint256 amount) external {
        require (IERC20(token1).balanceOf(msg.sender) >= amount, "insufficient balance");

        IERC20(token1).transfer(msg.sender, amount);
        emit WithdrawnToken1 (msg.sender, amount);
        
}

    function withdrawToken2(uint256 amount) external {
        require (IERC20(token2).balanceOf(msg.sender) >= amount, "insufficient balance");

        IERC20(token2).transfer(msg.sender, amount);
        emit WithdrawnToken2 (msg.sender, amount);

}

    function getBalance1() external view returns (uint256) {
        return IERC20(token1).balanceOf(address(this));
    }

    function getBalance2() external view returns (uint256) {
        return IERC20(token2).balanceOf(address(this));
    }
}

