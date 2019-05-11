App = {
    web3Provider: null,
    contracts: {},
    emptyAddress: "0x0000000000000000000000000000000000000000",
    sku: 1,
    upc: 1,
    metamaskAccountID: "0x0000000000000000000000000000000000000000",
    ownerID: "0x0000000000000000000000000000000000000000",
    originProducerID: "0x0000000000000000000000000000000000000000",
    originProducerName: null,
    originProducerInformation: null,
    originFarmLatitude: null,
    originFarmLongitude: null,
    productNotes: null,
    grapeType: null,
    harvestDate: 0,
    wineLotID: 0,
    fermentationTankID: 0,
    barrelID: 0,
    numDaysAging: 0,
    bottlingDate: 0,
    numBottlesLot: 0,
    numDaysResting: 0,
    wineLabel: null,
    certification: null,
    productPrice: 0,
    distributorID: "0x0000000000000000000000000000000000000000",
    retailerID: "0x0000000000000000000000000000000000000000",
    consumerID: "0x0000000000000000000000000000000000000000",
    certifierID: "0x0000000000000000000000000000000000000000",
    itemState: 0,

    init: async function () {
        App.readForm();
        /// Setup access to blockchain
        return await App.initWeb3();
    },

    readForm: function () {
        App.sku = $("#sku").val();
        App.upc = $("#upc").val();
        App.ownerID = $("#ownerID").val();
        App.originProducerID = $("#originProducerID").val();
        App.originProducerName = $("#originProducerName").val();
        App.originProducerInformation = $("#originProducerInformation").val();
        App.originFarmLatitude = $("#originFarmLatitude").val();
        App.originFarmLongitude = $("#originFarmLongitude").val();
        App.productNotes = $("#productNotes").val();
        App.grapeType = $("#grapeType").val();
        App.harvestDate = $("#harvestDate").val();
        App.wineLotID = $("#wineLotID").val();
        App.fermentationTankID = $("#fermentationTankID").val();
        App.barrelID = $("#barrelID").val();
        App.numDaysAging = $("#numDaysAging").val();
        App.bottlingDate = $("#bottlingDate").val();
        App.numBottlesLot = $("#numBottlesLot").val();
        App.numDaysResting = $("#numDaysResting").val();
        App.wineLabel = $("#wineLabel").val();
        App.certification = $("#certification").val();
        App.productPrice = $("#productPrice").val();
        App.distributorID = $("#distributorID").val();
        App.retailerID = $("#retailerID").val();
        App.consumerID = $("#consumerID").val();
        App.certifierID = $("#certifierID").val();

        console.log("readForm:",
            App.sku,
            App.upc,
            App.ownerID, 
            App.originProducerID, 
            App.originProducerName, 
            App.originProducerInformation, 
            App.originFarmLatitude, 
            App.originFarmLongitude, 
            App.grapeType,
            App.harvestDate,
            App.wineLotID,
            App.fermentatonTankID,
            App.barrelID,
            App.numDaysAging,
            App.bottlingDate,
            App.numBottlesLot,
            App.numDaysResting,
            App.wineLabel,
            App.certification,
            App.productNotes, 
            App.productPrice, 
            App.distributorID, 
            App.retailerID, 
            App.consumerID,
            App.certifierID
        );
    },

    populateForm: function() {
        $("#sku").val(App.sku);
        $("#upc").val(App.upc);
        $("#ownerID").val(App.ownerID );
        $("#originProducerID").val(App.originProducerID);
        $("#originProducerName").val(App.originProducerName);
        $("#originProducerInformation").val(App.originProducerInformation);
        $("#originFarmLatitude").val(App.originFarmLatitude);
        $("#originFarmLongitude").val(App.originFarmLongitude);
        $("#productNotes").val(App.productNotes);
        $("#grapeType").val(App.grapeType);
        $("#harvestDate").val(App.harvestDate);
        $("#wineLotID").val(App.wineLotID);
        $("#fermentationTankID").val(App.fermentationTankID);
        $("#barrelID").val(App.barrelID);
        $("#numDaysAging").val(App.numDaysAging);
        $("#bottlingDate").val(App.bottlingDate);
        $("#numBottlesLot").val(App.numBottlesLot);
        $("#numDaysResting").val(App.numDaysResting);
        $("#wineLabel").val(App.wineLabel);
        $("#certification").val(App.certification);
        $("#productPrice").val(App.productPrice);
        $("#distributorID").val(App.distributorID);
        $("#retailerID").val(App.retailerID);
        $("#consumerID").val(App.consumerID);
        $("#certifierID").val(App.certifierID);
    },

    initWeb3: async function () {
        /// Find or Inject Web3 Provider
        /// Modern dapp browsers...
        if (window.ethereum) {
            console.log("Using window ethereum provider");
            App.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
            } catch (error) {
                // User denied account access...
                console.error("User denied account access")
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            console.log("Using current provider");
            App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            console.log("Using local provider");
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
        }

        App.getMetaskAccountID();

        return App.initSupplyChain();
    },

    getMetaskAccountID: function () {
        web3 = new Web3(App.web3Provider);

        // Retrieving accounts
        web3.eth.getAccounts(function(err, res) {
            if (err) {
                console.log('Error:',err);
                return;
            }
            console.log('getMetaskID:',res);
            App.metamaskAccountID = res[0];

        })
    },

    initSupplyChain: function () {
        /// Source the truffle compiled smart contracts
        var jsonSupplyChain='../build/contracts/WineSupplyChain.json';
        console.log("JSON: " + jsonSupplyChain);
        
        /// JSONfy the smart contracts
        $.getJSON(jsonSupplyChain, function(data) {
            console.log('Found data: ', data);
            var SupplyChainArtifact = data;
            App.contracts.SupplyChain = TruffleContract(SupplyChainArtifact);
            App.contracts.SupplyChain.setProvider(App.web3Provider);

            // App.fetchItemBufferOne();
            // App.fetchItemBufferTwo();
            // App.fetchItemBufferThree();
            // App.fetchEvents();

        });

        return App.bindEvents();
    },

    bindEvents: function() {
        $(document).on('click', App.handleButtonClick);
    },

    handleButtonClick: async function(event) {
        App.readForm();
        event.preventDefault();

        App.getMetaskAccountID();

        var processId = parseInt($(event.target).data('id'));
        console.log('processId',processId);

        switch(processId) {
            case 1:
                return await App.harvestGrapes(event);
                break;
            case 2:
                return await App.processGrapes(event);
                break;
            case 3:
                return await App.produceWine(event);
                break;
            case 4:
                return await App.ageWine(event);
                break;
            case 5:
                return await App.bottleUpWine(event);
                break;
            case 6:
                return await App.restWine(event);
                break;
            case 7:
                return await App.labelWine(event);
                break;
            case 8:
                return await App.packWine(event);
                break;
            case 9:
                return await App.sellWine(event);
                break;
            case 10:
                return await App.buyWine(event);
                break;
            case 11:
                return await App.shipWine(event);
                break;
            case 12:
                return await App.receiveWine(event);
                break;
            case 13:
                return await App.purchaseWine(event);
                break;
            case 14:
                return await App.fetchItemBufferOne(event);
                break;
            case 15:
                return await App.fetchItemBufferTwo(event);
                break;
            case 16:
                return await App.fetchItemBufferThree(event);
                break;
            case 17:
                return await App.certifyWine(event);
                break;
            case 18:
                return await App.addProducer(event);
                break;
            case 19:
                return await App.addCertifier(event);
                break;
            case 20:
                return await App.addDistributor(event);
                break;
            case 21:
                return await App.addRetailer(event);
                break;
            case 22:
                return await App.addConsumer(event);
                break;
            case 23:
                return await App.fetchEvents(event);
                break;
        }
    },

    harvestGrapes: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.harvestGrapes(
                App.upc, 
                App.grapeType,
                App.metamaskAccountID, 
                App.originProducerName, 
                App.originProducerInformation, 
                App.originFarmLatitude, 
                App.originFarmLongitude, 
                App.productNotes,
                App.harvestDate
            );
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('harvestGrapes', result);
            App.fetchItemBufferOne();
            //App.updateItemHistory(App.upc, result.tx);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    processGrapes: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.processGrapes(App.upc, {from: App.metamaskAccountID});
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('processGrapes',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },
    
    produceWine: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.produceWine(
                App.upc, 
                App.wineLotID,
                App.fermentationTankID
            );
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('produceWine',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    ageWine: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.ageWine(
                App.upc, 
                App.barrelID,
                App.numDaysAging
            );
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('ageWine',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    bottleUpWine: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.bottleUpWine(
                App.upc, 
                App.bottlingDate,
                App.numBottlesLot
            );
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('bottleUpWine',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    restWine: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.restWine(
                App.upc, 
                App.numDaysResting
            );
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('restWine',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    labelWine: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.labelWine(
                App.upc, 
                App.wineLabel
            );
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('labelWine',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    certifyWine: function(event) {
        //event.preventDefault();
        //var processId = parseInt($(event.target).data('id'));
        console.log("account", App.metamaskAccountID);
        let producerID = $("#producerIDCert").val();
        let wineLabel = $("#wineLabelCert").val();
        let certification = $("#certificationGranted").val();
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.certifyWine(
                producerID, 
                wineLabel,
                certification, {from: App.metamaskAccountID}
            );
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('certifyWine',result);
            App.fetchItemBufferTwo();
            App.fetchItemBufferThree();
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    packWine: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.packWine(App.upc, {from: App.metamaskAccountID});
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('packWine',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    sellWine: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            const productPrice = web3.toWei(App.productPrice, "ether");
            console.log('productPrice', productPrice);
            return instance.sellWine(App.upc, productPrice, {from: App.metamaskAccountID});
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('sellWine',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    buyWine: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            const productPrice = web3.toWei(App.productPrice, "ether");
            return instance.buyWine(App.upc, {from: App.metamaskAccountID, value: productPrice});
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('buyWine',result);
            App.fetchItemBufferTwo();
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    shipWine: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.shipWine(App.upc, {from: App.metamaskAccountID});
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('shipWine',result);
            App.fetchItemBufferTwo();
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    receiveWine: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.receiveWine(App.upc, {from: App.metamaskAccountID});
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('receiveWine',result);
            App.fetchItemBufferTwo();
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    purchaseWine: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.purchaseWine(App.upc, {from: App.metamaskAccountID});
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('purchaseWine',result);
            App.fetchItemBufferTwo();
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    updateItemHistory: function(upc, txHash) {
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.updateItemHistory(upc, txHash, {from: App.metamaskAccountID});
        }).then(function(result) {
            console.log('updateItemHistory',result);
        }).catch(function(err) {
            console.log(err);
        });
    },

    addProducer: function() {
        let address = $("#address").val();
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.addProducer(address, {from: App.metamaskAccountID});
        }).then(function(result) {
            console.log('addProducer',result);
        }).catch(function(err) {
            console.log(err);
        });
    },

    addCertifier: function() {
        let address = $("#address").val();
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.addCertifier(address, {from: App.metamaskAccountID});
        }).then(function(result) {
            console.log('addCertifier',result);
        }).catch(function(err) {
            console.log(err);
        });
    },

    addDistributor: function() {
        let address = $("#address").val();
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.addDistributor(address, {from: App.metamaskAccountID});
        }).then(function(result) {
            console.log('addDistributor',result);
        }).catch(function(err) {
            console.log(err);
        });
    },

    addRetailer: function() {
        let address = $("#address").val();
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.addRetailer(address, {from: App.metamaskAccountID});
        }).then(function(result) {
            console.log('addRetailer',result);
        }).catch(function(err) {
            console.log(err);
        });
    },

    addConsumer: function() {
        let address = $("#address").val();
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.addConsumer(address, {from: App.metamaskAccountID});
        }).then(function(result) {
            console.log('addConsumer',result);
        }).catch(function(err) {
            console.log(err);
        });
    },

    fetchItemBufferOne: function () {
    ///   event.preventDefault();
    ///    var processId = parseInt($(event.target).data('id'));
        App.upc = $('#upc').val();
        console.log('upc', App.upc);

        App.contracts.SupplyChain.deployed().then(function(instance) {
            console.log(instance)
            return instance.fetchItemBufferOne(App.upc);
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('fetchItemBufferOne', result);
            App.sku = result[0];
            App.upc = result[1];
            App.ownerID = result[2];
            App.originProducerID = result[3];
            App.originProducerName = result[4];
            App.originProducerInformation = result[5];
            App.originFarmLatitude = result[6];
            App.originFarmLongitude = result[7];
            App.grapeType = result[8];
            App.populateForm();
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    fetchItemBufferTwo: function () {
    ///    event.preventDefault();
    ///    var processId = parseInt($(event.target).data('id'));
        App.upc = $('#upc').val();
        console.log('upc', App.upc);
                    
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.fetchItemBufferTwo(App.upc);
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('fetchItemBufferTwo', result);
            App.sku = result[0];
            App.upc = result[1];
            App.wineLabel = result[2];
            App.productNotes = result[3];
            App.productPrice = web3.fromWei(result[4], 'ether');
            App.itemState = result[5];
            App.certifierID = result[6];
            App.distributorID = result[7];
            App.retailerID = result[8];
            App.consumerID = result[9];
            App.populateForm();
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    fetchItemBufferThree: function () {
        App.upc = $('#upc').val();
        console.log('upc', App.upc);
                    
        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.fetchItemBufferThree(App.upc);
        }).then(function(result) {
            $("#ftw-item").text(result);
            console.log('fetchItemBufferThree', result);
            App.sku = result[0];
            App.upc = result[1];
            App.harvestDate = result[2];
            App.wineLotID = result[3];
            App.fermentationTankID = result[4];
            App.barrelID = result[5];
            App.numDaysAging = result[6];
            App.bottlingDate = result[7];
            App.numBottlesLot = result[8];
            App.numDaysResting = result[9];
            App.certification = result[10];
            App.populateForm();
        }).catch(function(err) {
            console.log(err.message);
        });
    },
    
    fetchEvents: function () {
        let txMap = new Map();
        console.log("cheguei aqui");
        if (typeof App.contracts.SupplyChain.currentProvider.sendAsync !== "function") {
            App.contracts.SupplyChain.currentProvider.sendAsync = function () {
                return App.contracts.SupplyChain.currentProvider.send.apply(
                    App.contracts.SupplyChain.currentProvider, arguments);
            };
        }

        App.contracts.SupplyChain.deployed().then(function(instance) {
            $("#ftw-events").empty();
            console.log("empty()");
            instance.allEvents({fromBlock: 0}, function(err, log) {
                console.log("event", log);
                if (!err && log.args.upc == App.upc) {   
                    console.log(log.transactionHash, txMap.get(log.transactionHash));
                    if (!txMap.has(log.transactionHash)) {
                        txMap.set(log.transactionHash, true);
                        console.log(log.transactionHash, txMap.get(log.transactionHash));
                        $("#ftw-events").append('<li>' + log.event + ' (upc: ' + log.args.upc + ') - ' + log.transactionHash + '</li>');
                    }
                }
            });
        }).catch(function(err) {
            console.log(err.message);
        });
        
    }
};

$(function () {
    $(window).load(function () {
        App.init();
    });
});
