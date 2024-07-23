// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract BikeRental {
    // Variables
    address payable public owner;
    uint256 public constant rentalPrice = 2 wei;
    uint256 public rentalDuration = 1 days;

    // Enum
    enum Statuses {
        Available, Rented
    }

    // Struct
    struct Bike {
        uint256 bikeId;
        string model;
        Statuses status;
        uint256 rentedUntil;
    }

    // Mapping
    mapping(uint256 => Bike) public bikes;

    // Events
    event Rent(address indexed renter, uint256 value, uint256 bikeId, uint256 rentedUntil);
    event Return(uint256 bikeId);
    event Refund(uint256 bikeId);

    // Constructor
    constructor() {
        owner = payable(msg.sender);
        bikes[1] = Bike(1, "Mountain Bike", Statuses.Available, 0);
        bikes[2] = Bike(2, "Road Bike", Statuses.Available, 0);
    }

    // Modifiers
    modifier onlyAvailable(uint256 bikeId) {
        require(bikes[bikeId].status == Statuses.Available, "Bike is not available!");
        _;
    }

    modifier costs(uint256 amount) {
        require(msg.value >= amount, "Insufficient funds!");
        _;
    }

    // EXECUTE FUNCTIONS
    function rentBike(uint256 bikeId) external payable onlyAvailable(bikeId) costs(rentalPrice) {
        bikes[bikeId].status = Statuses.Rented;
        bikes[bikeId].rentedUntil = block.timestamp + rentalDuration;
        emit Rent(msg.sender, msg.value, bikeId, bikes[bikeId].rentedUntil);
    }

    function returnBike(uint256 bikeId) external {
        require(block.timestamp >= bikes[bikeId].rentedUntil, "Bike is still rented!");

        bikes[bikeId].status = Statuses.Available;
        bikes[bikeId].rentedUntil = 0;
        emit Return(bikeId);
    }

    function refund(uint256 bikeId) external {
        require(bikes[bikeId].status == Statuses.Rented, "Bike is not rented!");
        bikes[bikeId].status = Statuses.Available;
        bikes[bikeId].rentedUntil = 0;
        payable(msg.sender).transfer(rentalPrice);
        emit Refund(bikeId);
    }

    // QUERY FUNCTIONS
    function getBikeStatus(uint256 bikeId) external view returns (Statuses) {
        return bikes[bikeId].status;
    }
}
