pragma solidity ^0.5.0;

// Import Core Ownable
import "../core/Ownable.sol";

// Import the library 'Roles'
import "./Roles.sol";

// Define a contract 'AccessControl' to manage all roles - add, remove, check
contract AccessControl is Ownable {
  
    using Roles for Roles.Role;

    // Define events, one for Adding, and other for Removing
    event ProducerAdded(address indexed account);
    event ProducerRemoved(address indexed account);

    event CertifierAdded(address indexed account);
    event CertifierRemoved(address indexed account);

    event ConsumerAdded(address indexed account);
    event ConsumerRemoved(address indexed account);

    event DistributorAdded(address indexed account);
    event DistributorRemoved(address indexed account);

    event RetailerAdded(address indexed account);
    event RetailerRemoved(address indexed account);

    // Define a structs by inheriting from 'Roles' library, struct Role
    Roles.Role internal producers;
    Roles.Role internal certifiers;
    Roles.Role internal consumers;
    Roles.Role internal distributors;
    Roles.Role internal retailers;

    event ProducerToBeConfirmed(address indexed account, bool result);

    // In the constructor make the address that deploys this contract the owner with all roles
    constructor() internal {
        _addProducer(msg.sender);
        _addCertifier(msg.sender);
        _addDistributor(msg.sender);
        _addRetailer(msg.sender);
        _addConsumer(msg.sender);
    }

    // Define a modifer that verifies the Caller
    modifier verifyCaller (address _address) {
        require(msg.sender == _address); 
        _;
    }

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyProducer() {
        require(isProducer(msg.sender));
        _;
    }

    // Define a function 'isProducer' to check this role
    function isProducer(address account) public view returns (bool) {
        return producers.has(account);
    }

    // Define a function 'addProducer' that adds this role
    function addProducer(address account) public onlyOwner {
        _addProducer(account);
    }

    // Define a function 'renounceProducer' to renounce this role
    function renounceProducer() public {
       _removeProducer(msg.sender);
    }

    // Define an internal function '_addProducer' to add this role, called by 'addProducer'
    function _addProducer(address account) internal {
        producers.add(account);
        emit ProducerAdded(account);
    }

    // Define an internal function '_removeProducer' to remove this role, called by 'removeProducer'
    function _removeProducer(address account) internal {
        producers.remove(account);
        emit ProducerRemoved(account);
    }

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyCertifier() {
        require(isCertifier(msg.sender));
        _;
    }

    // Define a function 'isCertifier' to check this role
    function isCertifier(address account) public view returns (bool) {
        return certifiers.has(account);
    }

    // Define a function 'addCertifier' that adds this role
    function addCertifier(address account) public onlyOwner {
        _addCertifier(account);
    }

    // Define a function 'renounceCertifier' to renounce this role
    function renounceCertifier() public {
        _removeCertifier(msg.sender);
    }

    // Define an internal function '_addCertifier' to add this role, called by 'addCertifier'
    function _addCertifier(address account) internal {
        certifiers.add(account);
        emit CertifierAdded(account);
    }

    // Define an internal function '_removeCertifier' to remove this role, called by 'removeCertifier'
    function _removeCertifier(address account) internal {
        certifiers.remove(account);
        emit CertifierRemoved(account);
    }

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyDistributor() {
        require(isDistributor(msg.sender));
        _;
    }

    // Define a function 'isDistributor' to check this role
    function isDistributor(address account) public view returns (bool) {
        return distributors.has(account);
    }

    // Define a function 'addDistributor' that adds this role
    function addDistributor(address account) public onlyProducer {
        _addDistributor(account);
    }

    // Define a function 'renounceDistributor' to renounce this role
    function renounceDistributor() public {
        _removeDistributor(msg.sender);
    }

    // Define an internal function '_addDistributor' to add this role, called by 'addDistributor'
    function _addDistributor(address account) internal {
        distributors.add(account);
        emit DistributorAdded(account);
    }

    // Define an internal function '_removeDistributor' to remove this role, called by 'removeDistributor'
    function _removeDistributor(address account) internal {
        distributors.remove(account);
        emit DistributorRemoved(account);
    }

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyRetailer() {
        require(isRetailer(msg.sender));
        _;
    }

    // Define a function 'isRetailer' to check this role
    function isRetailer(address account) public view returns (bool) {
        return retailers.has(account);
    }

    // Define a function 'addRetailer' that adds this role
    function addRetailer(address account) public onlyDistributor {
        _addRetailer(account);
    }

    // Define a function 'renounceRetailer' to renounce this role
    function renounceRetailer() public {
        _removeRetailer(msg.sender);
    }

    // Define an internal function '_addRetailer' to add this role, called by 'addRetailer'
    function _addRetailer(address account) internal {
        retailers.add(account);
        emit RetailerAdded(account);
    }

    // Define an internal function '_removeRetailer' to remove this role, called by 'removeRetailer'
    function _removeRetailer(address account) internal {
        retailers.remove(account);
        emit RetailerRemoved(account);
    }

    // Define a modifier that checks to see if msg.sender has the appropriate role
    modifier onlyConsumer() {
        require(isConsumer(msg.sender));
        _;
    }

    // Define a function 'isConsumer' to check this role
    function isConsumer(address account) public view returns (bool) {
        return consumers.has(account);
    }

    // Define a function 'addConsumer' that adds this role
    function addConsumer(address account) public onlyRetailer {
        _addConsumer(account);
    }

    // Define a function 'renounceConsumer' to renounce this role
    function renounceConsumer() public {
        _removeConsumer(msg.sender);
    }

    // Define an internal function '_addConsumer' to add this role, called by 'addConsumer'
    function _addConsumer(address account) internal {
        consumers.add(account);
        emit ConsumerAdded(account);
    }

    // Define an internal function '_removeConsumer' to remove this role, called by 'removeConsumer'
    function _removeConsumer(address account) internal {
        consumers.remove(account);
        emit ConsumerRemoved(account);
    }
}