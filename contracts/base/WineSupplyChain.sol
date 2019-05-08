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
  
    // For each producer, defines a certification per wine label
    mapping (address => mapping(string => Certification)) internal producerToWineLabelToCertification;

    State constant defaultState = State.GrapesHarvested;

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
        uint _price = items[_upc].productPrice;
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
        string memory _grapeType,
        address payable _originProducerID, 
        string memory _originProducerName, 
        string memory _originProducerInformation, 
        string memory _originFarmLatitude, 
        string memory _originFarmLongitude, 
        string memory _productNotes,
        uint _harvestDate
    ) public 
      onlyProducer
      isNewUpc(_upc) 
      verifyCaller(_originProducerID) 
    {
        // Add the new item as part of Harvest
        items[_upc] = Wine(
            sku,
            _upc,
            msg.sender,
            _originProducerID,
            _originProducerName,
            _originProducerInformation,
            _originFarmLatitude,
            _originFarmLongitude,
            _grapeType,
            _harvestDate,
            0, 0, 0, 0, 0, 0, 0, "", "",
            _productNotes,
            0,
            State.GrapesHarvested,
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
        // for (uint i=0; i<_numBottlesLot; i++) {
        //     sku += 1;
        //     upc += 1;
        //     Wine memory wine = Wine(
        //         sku,
        //         upc,
        //         msg.sender,
        //         items[_upc].originProducerID,
        //         items[_upc].originProducerName,
        //         items[_upc].originProducerInformation,
        //         items[_upc].originFarmLatitude,
        //         items[_upc].originFarmLongitude,
        //         items[_upc].grapeType,
        //         items[_upc].harvestDate,
        //         items[_upc].wineLotID,
        //         items[_upc].fermentationTankID,
        //         items[_upc].barrelID,
        //         items[_upc].numDaysAging,
        //         items[_upc].numDaysResting,
        //         items[_upc].bottlingDate,
        //         items[_upc].numBottlesLot,
        //         items[_upc].wineLabel,
        //         items[_upc].certification,
        //         items[_upc].productNotes,
        //         items[_upc].productPrice,
        //         items[_upc].itemState,
        //         items[_upc].certifierID,
        //         items[_upc].distributorID,
        //         items[_upc].retailerID,
        //         items[_upc].consumerID
        //     );
        //     items[upc] = wine;
        // }
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
    function certifyWine(address _producer, string memory _wineLabel, string memory _certification) public onlyCertifier {
        producerToWineLabelToCertification[_producer][_wineLabel] = Certification(msg.sender, _certification);
    }

    // Define a function 'labelWine' that allows a producer to mark an item 'WineLabeled'
    function labelWine(uint _upc, string memory _wineLabel) public 
        // Call modifier to check if upc has passed previous supply chain stage
        wineRested(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        address producer = items[_upc].originProducerID;
        // Update the appropriate fields
        items[_upc].wineLabel = _wineLabel;
        items[_upc].certification = producerToWineLabelToCertification[producer][_wineLabel].certification;
        items[_upc].certifierID = producerToWineLabelToCertification[producer][_wineLabel].certifierID;
        items[_upc].itemState = State.WineLabeled;
        // Emit the appropriate event
        emit WineLabeled(_upc, _wineLabel, producerToWineLabelToCertification[producer][_wineLabel].certification);
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
    function sellWine(uint _upc, uint _price) public 
        // Call modifier to check if upc has passed previous supply chain stage
        winePacked(_upc)
        // Call modifier to verify caller of this function
        verifyCaller(items[_upc].originProducerID) 
    {
        // Update the appropriate fields
        items[_upc].productPrice = _price;
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
        paidEnough(items[_upc].productPrice)
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
        uint price = items[_upc].productPrice;
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
        address originProducerID,
        string  memory originProducerName,
        string  memory originProducerInformation,
        string  memory originFarmLatitude,
        string  memory originFarmLongitude
    ) 
    {
        Wine storage wine = items[_upc];
        return 
        (
            wine.sku,
            wine.upc,
            wine.ownerID,
            wine.originProducerID,
            wine.originProducerName,
            wine.originProducerInformation,
            wine.originFarmLatitude,
            wine.originFarmLongitude
        );
    }

    // Define a function 'fetchItemBufferTwo' that fetches the data
    function fetchItemBufferTwo(uint _upc) public view returns 
    (
        uint    itemSKU,
        uint    itemUPC,
        string memory wineLabel,
        string memory productNotes,
        uint    productPrice,
        uint    itemState,
        address certifierID,
        address distributorID,
        address retailerID,
        address consumerID
    ) 
    {
        Wine storage wine = items[_upc];
        return 
        (
            wine.sku,
            wine.upc,
            wine.wineLabel,
            wine.productNotes,
            wine.productPrice,
            uint(wine.itemState),
            wine.certifierID,
            wine.distributorID,
            wine.retailerID,
            wine.consumerID
        );
    }

    // Define a function 'fetchItemBufferThree' that fetches the data
    function fetchItemBufferThree(uint _upc) public view returns 
    (
        uint    itemSKU,
        uint    itemUPC,
        uint    harvestDate,
        uint    wineLotID,
        uint    fermentationTankID,
        uint    barrelID,
        uint    numDaysAging,
        uint    bottlingDate,
        uint    numBottlesLot,
        uint    numDaysResting,
        string memory certification
    ) 
    {
        Wine storage wine = items[_upc];
        return 
        (
            wine.sku,
            wine.upc,
            wine.harvestDate,
            wine.wineLotID,
            wine.fermentationTankID,
            wine.barrelID,
            wine.numDaysAging,
            wine.bottlingDate,
            wine.numBottlesLot,
            wine.numDaysResting,
            wine.certification
        );
    }

}
