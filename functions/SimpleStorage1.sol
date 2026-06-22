// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.35;

contract SimpleStorage1 {


    uint256 public favoriteNumber;  // 0

   function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        retrive();
   }

    // view, pure used to read 
   function retrive() public view returns(uint256){
        return favoriteNumber;
   }

    // pure 
   function read() public pure returns(uint){
        return 7;
   }
}