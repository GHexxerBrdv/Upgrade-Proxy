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