// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.35;

contract SimpleStorage {

    // ─────────────────────────────────────────
    // STATE VARIABLES (were missing)
    // ─────────────────────────────────────────

    uint256[] public dynamicIds;

    mapping(address => uint256) public balances;

    enum Status { Pending, Active, Closed }
    Status public currentStatus;

    // ─────────────────────────────────────────
    // FUNCTIONS
    // ─────────────────────────────────────────

    function pushId(uint256 _id) public {
        dynamicIds.push(_id);
    }

    function getId(uint256 _index) public view returns (uint256) {
        return dynamicIds[_index];
    }

    function getArrayLength() public view returns (uint256) {
        return dynamicIds.length;
    }

    function setBalance(address _addr, uint256 _amount) public {
        balances[_addr] = _amount;
    }

    function getBalance(address _addr) public view returns (uint256) {
        return balances[_addr];
    }

    function setStatus(Status _status) public {
        currentStatus = _status;
    }
}