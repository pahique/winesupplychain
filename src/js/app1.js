const Web3 = require('web3');
const contractJson = require('../../build/contracts/WineSupplyChain.json');
const express = require('express');
const app = express();

let wineSupplyChain;

app.get('/winesupplychain/data1/:upc', function (req, res) {
    console.log('UPC: ' + req.params.upc);
    wineSupplyChain.methods.fetchItemBufferOne(req.params.upc).call().then((result) => {
        if (result[0] === '') {
            res.status(404).send('Not found');
        } else {
            res.type('json');
            res.json(result);
        }
    });
});

app.get('/winesupplychain/data2/:upc', function (req, res) {
    console.log('UPC: ' + req.params.upc);
    wineSupplyChain.methods.fetchItemBufferTwo(req.params.upc).call().then((result) => {
        if (result[0] === '') {
            res.status(404).send('Not found');
        } else {
            res.type('json');
            res.json(result);
        }
    });
});
  
app.get('/winesupplychain/data3/:upc', function (req, res) {
    console.log('UPC: ' + req.params.upc);
    wineSupplyChain.methods.fetchItemBufferThree(req.params.upc).call().then((result) => {
        if (result[0] === '') {
            res.status(404).send('Not found');
        } else {
            res.type('json');
            res.json(result);
        }
    });
});
  
app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
  if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
    console.log('using injected provider');
  } else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));  // Ganache
    //web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/"));  // Rinkeby Infura
    console.log('using http provider');
  }
  // The default (top) wallet account from a list of test accounts 
  web3.eth.defaultAccount = web3.eth.accounts[0];

  // The interface definition for your smart contract (the ABI) 
  console.log(contractJson.abi);
  wineSupplyChain = new web3.eth.Contract(contractJson.abi, '0x07D86841a582399E75269C51872731766D41D661');

  // Grab the contract at specified deployed address with the interface defined by the ABI
  console.log("Using WineSupplyChain contract at: " + wineSupplyChain.address);
});