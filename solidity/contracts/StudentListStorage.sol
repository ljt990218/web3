// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract StudentListStorage {
    struct Student {
        uint id;
        string name;
        uint age;
    }
    // 动态数组
    Student[] public StudentList; //自动getter()

    uint[] list = [1, 2, 3]; // 状态变量：数组 x

    function testLog(string memory _str) public pure returns (string memory) {
        return _str;
    }

    function testList() public view returns (uint[] memory) {
        return list;
    }

    function addStudentList(
        string memory _name,
        uint _age
    ) public returns (uint) {
        uint count = StudentList.length;
        uint index = count + 1;
        StudentList.push(Student(index, _name, _age));
        return StudentList.length;
    }

    function getStudentList() public view returns (Student[] memory) {
        // Student[] memory list = StudentList;
        return StudentList;
    }
}
