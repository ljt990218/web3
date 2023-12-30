const Contacts = artifacts.require('ArrayList')

module.exports = async function (callback) {
    const ArrayList = await Contacts.deployed()
    let res = await ArrayList.getArray()
    console.log(res)
    callback()
}
