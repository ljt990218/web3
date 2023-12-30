const Contacts = artifacts.require('StudentListStorage.sol')

module.exports = async function (callback) {
    const studentStorage = await Contacts.deployed()

    // await studentStorage.addStudentList('Liu11', 119)

    let res = await studentStorage.getStudentList()
    console.log(res)

    callback()
}
