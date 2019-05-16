# Instructions on how to use the DApp

1. At first, the user must fill in the UPC. That can be use either to create a new product on the blockchain or to search an existing product. SKU and OwnerID get populated by the smart contract and, therefore, are readonly. "Fetch Data1", "Fetch Data2", "Fetch Data3" and "Fetch Events" get data from the product given its UPC. The information is overwritten in the input fields. These button can be clicked any time.

![alt text](https://github.com/pahique/winesupplychain/docs/1.overview.png "Overview")

1. "Producer Actions" section group all the actions that can be taken by the producer. The first of them is "Harvest Grapes", and it requires as input a non-existing UPC, as well as the fields related to that operation. The ProducerID field is readonly and will be set as the sender of the message.

1. The next action is "Process Grapes" which currently does not require any input parameters. The only prerequisite is that the grapes related to that UPC be already harvested and that it be called by the producer who harvested them.

1. The next action is "Produce Wine", which requires that the grapes be already processed. As parameters, the producer can specify the wine lot number and fermentation tank id. Currently both are numeric values.

1. The same behavior is expected from "Age Wine", "Bottle up Wine" and "Rest wine". Each of them must be executed in a sequence.

1. "Label wine", the next step, has a different bahavior. The certification and certifierID are readonly and get populated automatically if, and only if, that wine label of the producer has been certified by a third party certifier. This certification, though, is optional. 

1. "Certify Producer", in section "Certifier Actions" and where a certifier can certify a producer and a chosen wine label. The certifier is the sender of the message and must have that role (see "Add Roles").

1. "Pack wine" is the next action, and currently does not require any parameter.

1. "Sell wine" is the action that specifies the price of the product, and a picture of it. That picture gets stored in IPFS, by uploading a new image or using an existing hash.

1. "Buy wine" is an action that can be performed only by a distributor, who must send enough ether in the message in order to become the owner of the product. 

1. Once the product is bought by the distributor, the "Ship wine" action can be called.

1. A retailer must call the "Receive wine" action against a shipped wine to become owner of the product. Note that in this simple DApp that operation can be called by any account with the retailer role, currently there is no source/destination check.

1. Once the wine is received by the retailer, an addres with the consumer role can call "Purchase wine" to get the ownership of the product. This is not a payable function, the only actor that gets paid in this simple blockchain is the producer of the wine.

1. The "Transaction History" section should get updated after each action related to the UPC, however that is not very accurate. It is recommended to call the "Fetch Events" action to get the list up to date.

1. "Add roles" is the section where new roles can be added to existing addresses, by following the rules below:

    * The owner of the contract has all roles.
    * Producers can be added only by the owner.
    * Certifiers can be added only by the owner.
    * Distributors can be added only by producers.
    * Retailers can be added only by distributors.
    * Consumers can be added only by retailers. 

