// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.35;

contract SimpleStorage {

    // ─────────────────────────────────────────
    // 1. VALUE TYPES
    // ─────────────────────────────────────────

    // Boolean
    bool public hasFavoriteNumber = true;

    // Unsigned Integers
    uint8   public smallNumber   = 255;
    uint256 public currentAge    = 22;

    // Signed Integers
    int8   public temperature     = -10;
    int256 public currentBalance  = 20000;

    // Address
    address public myAddress = 0x7eD04EF0c2dc4952d63088CE60f514089fF3383b;

    // Fixed-size Bytes
    bytes1  public singleByte = 0xFF;
    bytes32 public hashValue  = "thisIsRajMishra";

    // Enum
    enum Status { Pending, Active, Closed }
    Status public currentStatus; // default: Status.Pending (0)


    // ─────────────────────────────────────────
    // 2. REFERENCE TYPES
    // ─────────────────────────────────────────

    // String
    string public myName = "Raj Mishra";

    // Dynamic Bytes
    bytes public rawData = "hello";

    // Fixed-size Array
    uint256[3] public fixedScores = [10, 20, 30];

    // Dynamic Array
    uint256[] public dynamicIds;

    // Struct
    struct Person {
        string  name;
        uint256 age;
        bool    isActive;
    }
}