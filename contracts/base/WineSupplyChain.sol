pragma solidity ^0.5.0;

import './WineSupplyChainBase.sol';

contract WineSupplyChain is WineSupplyChainBase {

    // Define a variable called 'upc' for Universal Product Code (UPC)
    uint  upc;

    // Define a variable called 'sku' for Stock Keeping Unit (SKU)
    uint  sku;

    // Define a public mapping 'items' that maps the UPC to an Item.
    mapping (uint => Wine) items;

    // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash, 
    // that track its journey through the supply chain -- to be sent from DApp.
    mapping (uint => string[]) itemsHistory;
  
    // Stores a certification, for each producer, per wine label
    mapping (address => mapping(string => Certification)) internal certificationsGranted;


    // In the constructor set 'owner' to the address that instantiated the contract
    // and set 'sku' to 1
    // and set 'upc' to 1
    constructor() public payable {
        transferOwnership(msg.sender);
        sku = 1;
        upc = 1;
    }

    // Define a modifier that checks the price and refunds the remaining balance
    modifier checkValue(uint _upc) {
        _;
        uint _price = items[_upc].price;
        uint amountToReturn = msg.value - _price;
        msg.sender.transfer(amountToReturn);
    }

    // Check if the UPC is unique
    modifier isNewUpc(uint _upc) {
        require(items[_upc].upc == 0, "UPC already used");
        _;
    }

    // Define a modifier that checks if the paid amount is sufficient to cover the price
    modifier paidEnough(uint _price) { 
        require(msg.value >= _price, "Not enough"); 
        _;
    }

    // Define a modifier that checks if an item.state of a upc is GrapesHarvested
    modifier grapesHarvested(uint _upc) {
        require(items[_upc].itemState == State.GrapesHarvested);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is GrapesProcessed
    modifier grapesProcessed(uint _upc) {
        require(items[_upc].itemState == State.GrapesProcessed);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineProduced
    modifier wineProduced(uint _upc) {
        require(items[_upc].itemState == State.WineProduced);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineAged
    modifier wineAged(uint _upc) {
        require(items[_upc].itemState == State.WineAged);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineBottled
    modifier wineBottled(uint _upc) {
        require(items[_upc].itemState == State.WineBottled);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineRested
    modifier wineRested(uint _upc) {
        require(items[_upc].itemState == State.WineRested);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineLabeled
    modifier wineLabeled(uint _upc) {
        require(items[_upc].itemState == State.WineLabeled);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WinePacked
    modifier winePacked(uint _upc) {
        require(items[_upc].itemState == State.WinePacked);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineForSale
    modifier wineForSale(uint _upc) {
        require(items[_upc].itemState == State.WineForSale);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineSold
    modifier wineSold(uint _upc) {
        require(items[_upc].itemState == State.WineSold);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineShipped
    modifier wineShipped(uint _upc) {
        require(items[_upc].itemState == State.WineShipped);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WineReceived
    modifier wineReceived(uint _upc) {
        require(items[_upc].itemState == State.WineReceived);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is WinePurchased
    modifier winePurchased(uint _upc) {
        require(items[_upc].itemState == State.WinePurchased);
        _;
    }

    // Define a function 'harvestItem' that allows a producer to mark an item 'GrapesHarvested'
    function harvestGrapes
    (
        uint _upc, 
        string memory _originProducerName, 
        string memory _originProducerInformation, 
        string memory _originFarmLatitude, 
        string memory _originFarmLongitude, 
        string memory _grapeType,
        uint _harvestDate,
        string memory _harvestNotes
    ) public 
      onlyProducer
      isNewUpc(_upc) 
    {
        // Add the new item as part of Harvest
        items[_upc] = Wine(
            sku,
            _upc,
            msg.sender,
            State.GrapesHarvested,
            msg.sender,
            _originProducerName,
            _originProducerInformation,
            _originFarmLatitude,
            _originFarmLongitude,
            _grapeType,
            _harvestDate,
            _harvestNotes,
            0, 0, 0, 0, 0, 0, 0, "", "", "",
            0, "",
            address(0),
            address(0),
            address(0),
            address(0)
        );
        // Increment sku
        sku = sku + 1;
        // Emit the appropriate event
        emit GrapesHarvested(_upc, _grapeType, _harvestDate);
    }

    // Define a function 'processtGrapes' that allows a producer to mark an item 'GrapesProcessed'
    function processGrapes(uint _upc) public 
        // Call modifier to check if upc has passed previous supply chain stage
        grapesHarvested(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID)
    {
        // Update the appropriate fields
        items[_upc].itemState = State.GrapesProcessed;
        // Emit the appropriate event
        emit GrapesProcessed(_upc);
    }

    // Define a function 'produceWine' that allows a producer to mark an item 'WineProduced'
    function produceWine(uint _upc, uint _wineLotID, uint _fermentationTankID) public 
        // Call modifier to check if upc has passed previous supply chain stage
        grapesProcessed(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        // Update the appropriate fields
        items[_upc].wineLotID = _wineLotID;
        items[_upc].fermentationTankID = _fermentationTankID;
        items[_upc].itemState = State.WineProduced;
        // Emit the appropriate event
        emit WineProduced(_upc, _wineLotID, _fermentationTankID);
    }

    // Define a function 'ageWine' that allows a producer to mark an item 'WineAged'
    function ageWine(uint _upc, uint _barrelID, uint _numDaysAging) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineProduced(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        // Update the appropriate fields
        items[_upc].barrelID = _barrelID;
        items[_upc].numDaysAging = _numDaysAging;
        items[_upc].itemState = State.WineAged;
        // Emit the appropriate event
        emit WineAged(_upc, _barrelID, _numDaysAging);
    }

    // Define a function 'bottleUpWine' that allows a producer to mark an item 'WineBottled'
    function bottleUpWine(uint _upc, uint _bottlingDate, uint _numBottlesLot) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineAged(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        // Update the appropriate fields
        items[_upc].bottlingDate = _bottlingDate;
        items[_upc].numBottlesLot = _numBottlesLot;
        items[_upc].itemState = State.WineBottled;
        // Emit the appropriate event
        emit WineBottled(_upc, _bottlingDate, _numBottlesLot);
    }

    // Define a function 'restWine' that allows a producer to mark an item 'WineRested'
    function restWine(uint _upc, uint _numDaysResting) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineBottled(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        // Update the appropriate fields
        items[_upc].numDaysResting = _numDaysResting;
        items[_upc].itemState = State.WineRested;
        // Emit the appropriate event
        emit WineRested(_upc, _numDaysResting);
    }

    // Define a function 'certifyWine' that allows a certifier to apply a wine certification to a label
    function certifyProducer(address _producer, string memory _wineLabel, string memory _certification) public onlyCertifier {
        certificationsGranted[_producer][_wineLabel] = Certification(msg.sender, _certification);
    }

    // Define a function 'labelWine' that allows a producer to mark an item 'WineLabeled'
    function labelWine(uint _upc, string memory _wineLabel, string memory _wineInformation) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineRested(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        address producer = items[_upc].originProducerID;
        // Update the appropriate fields
        items[_upc].wineLabel = _wineLabel;
        items[_upc].wineInformation = _wineInformation;
        items[_upc].certification = certificationsGranted[producer][_wineLabel].certification;
        items[_upc].certifierID = certificationsGranted[producer][_wineLabel].certifierID;
        items[_upc].itemState = State.WineLabeled;
        // Emit the appropriate event
        emit WineLabeled(_upc, _wineLabel, certificationsGranted[producer][_wineLabel].certification);
    }

    // Define a function 'packWine' that allows a producer to mark an item 'WinePacked'
    function packWine(uint _upc) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineLabeled(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        // Update the appropriate fields
        items[_upc].itemState = State.WinePacked;
        // Emit the appropriate event
        emit WinePacked(_upc);
    }

    // Define a function 'sellWine' that allows a producer to mark an item 'WineForSale'
    function sellWine(uint _upc, uint _price, string memory _imageHash) public 
        // Call modifier to check if upc has passed previous supply chain stage
        winePacked(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        // Update the appropriate fields
        items[_upc].price = _price;
        items[_upc].imageHash = _imageHash;
        items[_upc].itemState = State.WineForSale;
        // Emit the appropriate event
        emit WineForSale(_upc, _price);
    }

    // Define a function 'buyWine' that allows the distributor to mark an item 'WineSold'
    // Use the above defined modifiers to check if the item is available for sale, if the buyer has paid enough, 
    // and any excess ether sent is refunded back to the buyer
    function buyWine(uint _upc) public payable 
        // Call modifier to check if upc has passed previous supply chain stage
        wineForSale(_upc)
        // Call modifer to check if buyer has paid enough
        paidEnough(items[_upc].price)
        // Call modifer to send any excess ether back to buyer
        checkValue(_upc)
        // Call modifier to verify caller of this function
        onlyDistributor
    {
        // Update the appropriate fields - ownerID, distributorID, itemState
        items[_upc].ownerID = msg.sender;
        items[_upc].distributorID = msg.sender;
        items[_upc].itemState = State.WineSold;
        // Transfer money to producer
        uint price = items[_upc].price;
        items[_upc].originProducerID.transfer(price);
        // emit the appropriate event
        emit WineSold(_upc);
    }

    // Define a function 'shipWine' that allows the distributor to mark an item 'WineShipped'
    // Use the above modifers to check if the item is sold
    function shipWine(uint _upc) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineSold(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].distributorID)
    {
        // Update the appropriate fields
        items[_upc].itemState = State.WineShipped;
        // Emit the appropriate event
        emit WineShipped(_upc);
    }

    // Define a function 'receiveWine' that allows the retailer to mark an item 'WineReceived'
    // Use the above modifiers to check if the item is shipped
    function receiveWine(uint _upc) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineShipped(_upc)
        // Access Control List enforced by calling Smart Contract / DApp
        onlyRetailer
    {
        // Update the appropriate fields - ownerID, retailerID, itemState
        items[_upc].ownerID = msg.sender;
        items[_upc].retailerID = msg.sender;
        items[_upc].itemState = State.WineReceived;
        // Emit the appropriate event
        emit WineReceived(_upc);
    }

    // Define a function 'purchaseWine' that allows the consumer to mark an item 'WinePurchased'
    // Use the above modifiers to check if the item is received
    function purchaseWine(uint _upc) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineReceived(_upc)
        // Access Control List enforced by calling Smart Contract / DApp
        onlyConsumer
    {
        // Update the appropriate fields - ownerID, consumerID, itemState
        items[_upc].ownerID = msg.sender;
        items[_upc].consumerID = msg.sender;
        items[_upc].itemState = State.WinePurchased;
        // Emit the appropriate event
        emit WinePurchased(_upc);
    }

    // Define a function 'fetchItemBufferOne' that fetches the data
    function fetchItemBufferOne(uint _upc) public view returns 
    (
        uint    itemSKU,
        uint    itemUPC,
        address ownerID,
        uint    itemState,
        address originProducerID,
        string  memory originProducerName,
        string  memory originProducerInformation,
        string  memory originFarmLatitude,
        string  memory originFarmLongitude,
        string  memory grapeType
    ) 
    {
        Wine storage wine = items[_upc];
        return 
        (
            wine.sku,
            wine.upc,
            wine.ownerID,
            uint(wine.itemState),
            wine.originProducerID,
            wine.originProducerName,
            wine.originProducerInformation,
            wine.originFarmLatitude,
            wine.originFarmLongitude,
            wine.grapeType
        );
    }

    // Define a function 'fetchItemBufferTwo' that fetches the data
    function fetchItemBufferTwo(uint _upc) public view returns 
    (
        uint    itemUPC,
        uint    harvestDate,
        string memory harvestNotes,
        uint    wineLotID,
        uint    fermentationTankID,
        uint    barrelID,
        uint    numDaysAging,
        uint    bottlingDate,
        uint    numBottlesLot,
        uint    numDaysResting
    ) 
    {
        Wine storage wine = items[_upc];
        return 
        (
            wine.upc,
            wine.harvestDate,
            wine.harvestNotes,
            wine.wineLotID,
            wine.fermentationTankID,
            wine.barrelID,
            wine.numDaysAging,
            wine.bottlingDate,
            wine.numBottlesLot,
            wine.numDaysResting
        );
    }

    // Define a function 'fetchItemBufferThree' that fetches the data
    function fetchItemBufferThree(uint _upc) public view returns 
    (
        uint    itemUPC,
        string memory wineLabel,
        string memory wineInformation,
        string memory certification,
        address certifierID,
        uint    price,
        string memory imageHash,
        address distributorID,
        address retailerID,
        address consumerID
    ) 
    {
        Wine storage wine = items[_upc];
        return 
        (
            wine.upc,
            wine.wineLabel,
            wine.wineInformation,
            wine.certification,
            wine.certifierID,
            wine.price,
            wine.imageHash,
            wine.distributorID,
            wine.retailerID,
            wine.consumerID
        );
    }

    // Includes a transaction hash associated to a UPC
    function updateItemHistory(uint _upc, string memory _txHash) public onlyOwner {
        itemsHistory[_upc].push(_txHash);
    }

}