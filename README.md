# Hii all, I had started an open source project on smart contract upgradable proxies.

# Mostly there are 5 type of upgradability. 
* Eternal Storage
* Transparent
* UUPS proxy
* Beacon
* Dimond

There are theories and concepts out there for these proxies. But as far as i know there is not example of them so that beginner can understand it properly, and how they work under the hood with minimalistic to advance example.

So i have decided to start a open source project in which these 5 types of proxies and smart contract upgradabiliy are implementated in minimal level. So that any learner and beginner can contribute into this project and make it bigger and modular. Yep in this project they will get hands on experience of how solidity actually works under the hood, How low level call works like delegatecall etc. Also participants can open their contribution portfolio from this beginner friendly project. 

Yeah, i am alone could make it but i though what if everyone can participate and contribute whether it is code contribution or docs contribution, in that way any one can learn from this and we also can contribute to the web 3 space. 

The first phase or  minimal implementation of Eternal upgradability proxy has completed already by me. but the journey is not completed yet. We can make this project advance from minimal. 

I hope you all will exited to learn and contribute in the space and project. Interested people just raise issue in following repository whether it is code contribution or docs contribution.

`https://github.com/GHexxerBrdv/Upgrade-Proxy.git`.

I hope every one will understand the importance of the project. happy to see you all in contributions.

# what is Proxy and Upgradability?

- well you all knows that smart contracts are immutable `"after deployed on chain"`. You can not change the logic of deployed smart contract. Now there is a magic here. What if i say you can change the logic of smart contract. is it magical is it?
- well you have heard of the quote `"If you can not change the girl, then change the girl"`. It is painful for humans but if you apply this quote `"If you can not change logic of smart contract, then change the smart contract"`. that is not painful for humans.

If you have changed the smart contract then how the end user will interact with updated/changed contract? There is the `Proxy` comes in role. Proxy are the smart contract which points to the another contract. And through proxy contract end user can interact with smart contract.

# Now how can you upgrade smart contract?

There are mainly 5 types of upgradability patterns in blockchain.

## Eternal Storage upgradability pattern:

* As name suggested `Eternal Storage`, There is a `eternal` storage contract which will hold data or storage variables. The contract will not updated after deployment. This contract will have torage valiables in form of `key-value` form like mapping. `eg. bytes32 => uint256`. the contract has simple getter and setter functions for storage variables.
* There is another contract that will point to the `Eternal storage` contract. this contract will hold main logic for manipulating or performing different operations on storage variables. 
* `Proxy` contract, that is another contract which will points to appropriate updated `implementation/logic` contract. The end user will be able to interact with storage variables and logic contract logic via this proxy contract.

The simple architecture of `Eternal storage upgradability`.

```
User -> proxy contract -> logic contract -> storage contract.
```

There can be multiple logic contract that can point to the storage contract. the proxy contract will be pointing to upto date new implementation contract.

Why we need to do this? to make storage persistance accross the logic. Why? because if you make and deploy another contract with their own storage variables and updated functionalities then old values will be lost, and the new values will be start with zero. The `Eternal Storage upgradability` pattern will solve this issue. and make storage unchanged accross the multiple logic contracts.

## Transparent Upgradable Proxy Pattern:

The Transparent Upgradable Proxy is one of the most widely used proxy patterns in Ethereum smart contract development. 