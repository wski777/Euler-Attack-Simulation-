// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleLending {
    mapping(address => uint) public collateral;
    mapping(address => uint) public debt;

    uint public constant THRESHOLD = 75; // 75%

    event Deposited(address user, uint amount);
    event Borrowed(address user, uint amount);
    event Donated(address user, uint amount);
    event Liquidated(address user, address liquidator, uint collateralSeized);

    function deposit() external payable {
        collateral[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function borrow(uint amount) external {
        require(isHealthy(msg.sender), "Unhealthy");
        debt[msg.sender] += amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "ETH transfer failed");
        emit Borrowed(msg.sender, amount);
    }

    function donateToReserves(uint amount) external {
        require(collateral[msg.sender] >= amount, "Not enough collateral");
        collateral[msg.sender] -= amount;
        emit Donated(msg.sender, amount);
    }

    function liquidate(address user) external {
        require(!isHealthy(user), "User is healthy");
        uint debtAmount = debt[user];
        uint collateralAmount = collateral[user];
        require(collateralAmount > 0, "No collateral");

        delete debt[user];
        delete collateral[user];

        (bool success, ) = msg.sender.call{value: collateralAmount}("");
        require(success, "ETH transfer failed");

        emit Liquidated(user, msg.sender, collateralAmount);
    }

    function isHealthy(address user) public view returns (bool) {
        if (debt[user] == 0) return true;
        return (collateral[user] * 100) / debt[user] >= THRESHOLD;
    }

    function getHealth(address user) external view returns (uint) {
        if (debt[user] == 0) return type(uint).max;
        return (collateral[user] * 100) / debt[user];
    }
}
