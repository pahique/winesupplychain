var WineSupplyChain = artifacts.require("./WineSupplyChain.sol");

module.exports = function(deployer) {
    deployer.deploy(WineSupplyChain);
};

