const Contacts = artifacts.require('StudentStorage.sol')

module.exports = async function (callback) {
    const studentStorage = await Contacts.deployed()

    await studentStorage.setStudent('Liu', 18)

    let res = await studentStorage.getStudent()
    console.log(res)

    callback()
}
