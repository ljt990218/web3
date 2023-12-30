// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayList {
    uint256[] public myArray;

    constructor() {
        myArray.push(10);
        myArray.push(20);
        myArray.push(30);
    }

    function getArray() public view returns (uint256[] memory) {
        return myArray;
    }
}
