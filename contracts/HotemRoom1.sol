//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;
contract HotemRoom {
    // Variables
    address payable  public owner;
    uint256 public constant roomPrice = 2 wei;
    uint256 public bookingDuration = 1 days;
    // Enum
    enum Statuses {
        Available, Rented
    }

    // Struct
    struct Room {
        uint256 roomNumber;  
        string title;
        Statuses status;
        uint256 rentedUntil; 
    }
    //Mapping
    mapping(uint256 => Room) public rooms;
    // Event
    event CheckIn(address indexed _client, uint256 _value, uint256 _roomNumber, uint256 _rentedUntil);
    event CheckOut(uint256 _roomNumber);
    event Refund(uint256 _roomNumber);

    // Constructor
    constructor() {
        owner = payable(msg.sender);
        rooms[1] = Room(1,"Deluxe Room", Statuses.Available,0);
        rooms[2] = Room(2,"Standart Room", Statuses.Available,0);
    }
    // Modifier
    modifier onlyAvailable(uint256 _roomNumber) {
        require(rooms[_roomNumber].status == Statuses.Available,"Oda musait degil!");
        _;
    }
    modifier costs (uint256 _amount) {
        require(msg.value >= _amount, "Yetersiz Bakiye!");
        _;
    }
    // EXECUTE FUNC
    function checkIn(uint256 _roomNumber) external payable onlyAvailable(_roomNumber) costs(roomPrice){
        rooms[_roomNumber].status = Statuses.Rented;
        rooms[_roomNumber].rentedUntil =block.timestamp + bookingDuration;
        emit CheckIn(msg.sender, msg.value, _roomNumber, rooms[_roomNumber].rentedUntil);
    }
    function checkOut(uint256 _roomNumber) external {
        require(block.timestamp >= rooms[_roomNumber].rentedUntil, "Oda zaten kiralik durumda!");
        
        rooms[_roomNumber].status = Statuses.Available;
        rooms[_roomNumber].rentedUntil = 0;
        emit CheckOut(_roomNumber);
    }
    function refund(uint256 _roomNumber) external {
        require(rooms[_roomNumber].status == Statuses.Rented, "Oda zaten kiralik durumda!");
        rooms[_roomNumber].status = Statuses.Available;
        rooms[_roomNumber].rentedUntil = 0;
        payable(msg.sender).transfer(roomPrice);
        emit Refund(_roomNumber);
    }
    // QUERY FUNC
    function getRoomStatus(uint256 _roomNumber) external view returns(Statuses) {
        return rooms[_roomNumber].status;
    }
}
