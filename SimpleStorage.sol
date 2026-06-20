// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.35;

contract SimpleStorage {

    uint256 public favoriteNumber;

    function store(uint256 _number) public {
        favoriteNumber = _number;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }
}