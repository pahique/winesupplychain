# Wine Supply Chain Project

This blockchain project is a simplified version of a wine supply chain.

## Versions used in this project

    * truffle version

        Truffle v5.0.13 (core: 5.0.13)
        Solidity v0.5.0 (solc-js)
        Node v11.13.0
        Web3.js v1.0.0-beta.37
    
    * npm 6.7.0  (used to start up lite-server)
    * lite-server 2.4.0
    * truffle-hdwallet-provider 1.0.8  (for deployment on Rinkeby network)
    * bignumber.js 8.1.1 (used only in Truffle tests)
    
## Installation Steps

On the root folder, install the following packages:

1. `npm install lite-server`
1. `npm install truffle-hdwallet-provider --save`
1. `npm install bignumber.js`

## Development Steps

1. Change directory to the root folder of the project
1. `truffle develop`
    1. `compile`
    1. `migrate --reset`
    1. `test`

1. On another terminal, run `npm run dev`
1. On Metamask, in the browser, use network `http://localhost:9545`
1. Open page `http://localhost:3000/src/index.html`

## RINKEBY 

1. Change directory to the root folder of the project
1. `truffle compile`
1. `truffle migrate --network rinkeby`
1. On another terminal, run `npm run dev`
1. On Metamask, in the browser, select **Rinkeby Test Network**
1. Open page `http://localhost:3000/src/index.html`

* Contract Address: `0x056696DE24aEF48abb4c6F5532a42da48dBDe3aF`
* Transaction Hash: `0xc5c14c1c2f93d66c214b71b0ce6d45fab5418bcdee2fd8f43492efd85e56c926`
* Owner account: `0x14648D1222B257f63528Fb1cEB3964E008bef522`

## IPFS

IPFS is used by the DApp in order to store product images, and that is done by calling Infura's API via javascript. 

Besides that, the full DApp has also been uploaded to IPFS, and can be accessed through the link below: 

https://ipfs.io/ipfs/QmTMjeLSJBqHrbE9u9jsn2ebXMMC3Mn4j5AAtUz5XpSUUn/index.html

## Extra documentation

* [User guide](https://github.com/pahique/winesupplychain/blob/master/docs/README.md)
* [UML Diagrams](https://github.com/pahique/winesupplychain/blob/master/docs/uml-diagrams/README.md)



