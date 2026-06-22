// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.35;

contract SimpleStorage1 {


    uint myfavoriteNumber; // 0

    // uint256[] public listOfFavoriteNumber;  

    struct Person {
        uint favoriteNumber;
        string name;
    }

    // Dynamic array
    Person[] public listOfPersons;

    // Static array
    Person[4] public listOfFavoritePersons;

    
    // calldata, memory, storage
   function addPersons(string memory _name, uint256 _favoriteNumber) public {
        // Person memory newPerson = Person(_favoriteNumber, _name);
        // listOfPersons.push(newPerson);

        listOfPersons.push(Person(_favoriteNumber, _name));
   }

}