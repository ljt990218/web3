const Contacts = artifacts.require('ArrayList.sol')

module.exports = function (deployer) {
    deployer.deploy(Contacts)
}
