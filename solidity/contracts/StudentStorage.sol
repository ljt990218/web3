// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract StudentStorage {
    string name;
    uint age;

    function setStudent(string memory _name, uint _age) public {
        name = _name;
        age = _age;
    }

    // view (视图函数，只访问不修改)  pure (纯函数，不修改状态)
    function getStudent() public view returns (string memory, uint) {
        return (name, age);
    }
}
