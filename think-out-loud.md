# URL of finished repo
https://github.com/01Clarian/nft-marketplace-solution/

## the line to remove git files after cloning project that I always forget

`$ rm -rf .git` or `$ rm -rf <repo_folder>/.git` if in other directory

migrations folder

- migrate our smart contracts onto the blockchain
- test out contracts first, when they are good to deploy, migrate to new address for production

# Work with truffle

- `npm install -g truffle` - install truffle globally
- `truffle init`
  Problem: unable to install truffle globally
  Solution: after npm install, truffle is installed locally, run `npx truffle init` instead
  https://ethereum.stackexchange.com/questions/94575/cannot-install-truffle-node-js-and-npm-are-installed

`truffle-config.js` have some common configs, but need to decide which ones to use by un-commenting lines ourself

## one-liner to add and commit that I always forget

`git add . && git commit -am "comment"`

## IDE always underline the 1st line pragma solidity version

- just as I thought, it's because of the Solidity version in settings

## prettier doesn't work with solidity (A problem I solved but forgot)

- `npm install --save-dev prettier-plugin-solidity`
- set "prettier" as formatter in settings

## What's the migrations folder for?

- What are those functions inside this folder about?
- what is that `artifacts.require()` thing

"artifacts not found"

- In each migration file with the undefined artifacts.require(), require the following at the top of the file --->
- `const { artifacts } = require("truffle");`
  https://github.com/trufflesuite/truffle/issues/3728#issuecomment-980249895

* But turn out no need to write this line

`truffle compile` doesn't work, as truffle isn't installed globally

- needs to run `npx truffle compile`

Got this error with truffle 5.0.5
"TypeError: Error parsing C:/Users/coding-guy/Documents/blockchain/nft-marketplace/src/contracts/KryptoBirdz.sol: Cannot read properties of undefined (reading 'addFunction')"

- updated tp 5.1.5, got rid of error above, but got another error:
  "Error: TypeError: Cannot read properties of undefined (reading 'slice')
  at Object.compile (C:\Users\coding-guy\Documents\blockchain\nft-marketplace\node_modules\truffle\build\webpack:\packages\workflow-compile\legacy\index.js:80:1)"

## Confusion comes from naming

file name: `KryptoBirdz.sol`
contract name inside the above file: `KryptoBird` without the `z`

- when calling truffle compile, compile the sol into .json in `abis` folder
- when calling truffle migrate, deploy the `abis` to the blockchain
- `artifacts.require('KryptoBird')`: the `KryptoBird` argument here is refers to the `KryptoBird.json`
- because the names of everything was `KryptoBirdz` with a `z`, but in the require() call the argument is `KryptoBird` with No `z`, and there's only `KryptoBirdz.json` not `KryptoBird.json`, so it says can't read the file.

# truffle console
`npx truffle console`

# use `await` keyword to deploy the abis on chain?

`KryptoBird = await KryptoBird.deployed()`

- notice the method name is `deployed()`

# build from scratch without using openzeppelin
- separate contract for
  - metadata
  - interface
  - enumerating
- these adhere to the standard of ERC721

## string memory
- typically string is temporary stored in memory, because strings are variables that have memory location, and then they get wiped out

## `truffle migrate --reset`
- move to the new address (instead of changing previously deployed contracts on the chain), run a reset after compile

I still don't understand the truffle console environment.
- When I typed `test = await KryptoBird.deployed()` it compiles the contract again, when finished `test` is not defined.
- But when I typed `KryptoBird = await KryptoBird.deployed()` and access the getName method by `KryptoBird.getName()` then it works.
- apparently KryptoBird refers to the .json file of the same name in the abis folder (at first)

ERC721 specification does not include standard function for burning and minting 
- `KryptoBird` is only going to be executing what we want the KryptoBird marketplace going to do
- can write anywhere we want technically, but should be written in ERC contracts as it's part of the standardized things like creation, minting 

Event: one directional event of logs that keep track of blockchain data

2nd argument in `require()`: an error message

## `indexed` - what does it do?
- searching through
- save gas
- can use up to 3 index per event
- But what does it do exactly?

`mint()`
- when mint() is called:
- "from" is the address in Ganache, that is the `msg.sender`
- "to" is the address of the contract, that means the minted token is stored in the contract itself

## console command always typed in:
kryptoBird = await KryptoBird.deployed()
kryptoBird.getName()
  - check if able to access getter function

kryptoBird.mint('1st')
kryptoBird.mint('2nd')
kryptoBird.mint("http...1")
kryptoBird.mint("http...2")

kryptoBird.balanceOf("0x29c8dB5729431c43D7Dde7ABC60aC5294f39E9F6").then(function(balance) {balanceInstance = balance})
kryptoBird.balanceOf("0xdFA74188Ddedc05BFDeB4035d56AD1dA5071961c").then(function(balance) {balanceInstance = balance})

kryptoBird.totalSupply().then(function(balance) {balanceInstance = balance})

kryptoBird.ownerOf(0)

kryptoBird.transferFrom('0x29c8dB5729431c43D7Dde7ABC60aC5294f39E9F6', '0xdFA74188Ddedc05BFDeB4035d56AD1dA5071961c', 0)


# write balanceOf() ourself that adhere to the ERC721 standard

## seems "zero" address is something special?
- there is this `address(0)` thing to check if the address is zero in tutorial


## `virtual` modifier in function definition
- so that other contracts inherit from it can use `override` keyword to override this function

## duplicated inheritance is not allowed in newer version of compiler
e.g.
- `ERC721Connector` inherits from `ERC721Enumerable`, `ERC721Enumerable` inherits from `ERC721`
- `ERC721Connector` shouldn't inherit from `ERC721` because the child `ERC721Enumerable` already inherits from `ERC721`


## why always need to keep track of index of something in Solidity?


## so approving a transfer needs four steps:
- require the person approving is the actual owner of the token
- require we can't send token from the owner to the owner himself (current caller)
- update the map of the approval addresses
- approving an address to a tokenId - broadcast the transfer if all the requirements are fulfilled
  - `emit Approval()` 

# ERC-165
- Every ERC-721 compliant contract must implement interface of both ERC-721 and ERC-165.
- ERC-165 standard is just a way of checking if your contract's data match the data of any given contract. 

## interface
An interface is like an abstract contract, but you can only define unimplemented functions.
- in ERC721 interface, all the unimplemented functions are added up to some bytes 

Overload vs override
- Overload - same name same definition in both parent and child
- Override - function in child component overrides parent's definition 

# ERC165 and bytes
- Not sure what is `bytes4` and `supportedInterfaces` about.
- what is "registering fingerprint data"?

If a contract inherits from an interface:
- the contract has to implement all the functions defined in the interface, otherwise the compiler will throw an error
- functions in the child should have `override` keyword to replace the definition in the parent interface

In the constructor of ERC721.sol:
```
  constructor() {
    _registerInterface(
      bytes4(
        keccak256('balanceOf(bytes4)') ^
          keccak256('ownerOf(bytes4)') ^
          keccak256('transferFrom(bytes4)')
      )
    );
  }
```
From what I understand now, because it is calculating the size of those three functions inherit from the interface:
- `balanceOf()`
- `ownerOf()`
- `transferFrom()`
Does it mean that "registering interface" actually mean to calculate the total byte size of the interface functions that are inherit from the interface?


# Truffle test suite
mocha.js
chai.js

## What is artifacts?
"Artifacts are simply the JSON files of the contracts. the meaning of artifact in software is anything that is created so a piece of software can be developed."
https://ethereum.stackexchange.com/questions/30457/what-are-artifacts-in-truffle/97201


# Test
- Each describe() is a test container
- each describe is a scope block


# Bootstrap
- Import Bootstrap in index.js, the whole app has access to Bootstrap
- constructor() in class based React is to handle state
- shortcut cheat sheet: https://hackerthemes.com/bootstrap-cheatsheet/

# Front end interface using React
- Before doing anything, we want to make sure the user load the metamask wallet and connect properly
- Without the wallet, marketplace won't work

Most important lines in `async loadWeb3()`:
```
const provider = await detectEthereumProvider()

window.web3 = new Web3(provider)

// what is this line about?
await window.ethereum.enable()
```

`async loadBlockchainData()`:
- get the metamask account information
- get the network ID to grab the contract, then we can access things like totalSupply, how many NFTs were minted
- get the contract abi and address (recall when interact with contract on chain, we need its abi and address (that the contract is deployed to))
- ? why need to create a new instance of a contract with that abi and address?

## opening a file from another directory in vscode 
`code -r <fileName>`

The error encounted when press on mint button is solved by resetting Metamask
https://ethereum.stackexchange.com/questions/89879/error-ethjs-query-while-formatting-outputs-from-rpc-messageinvalid-sende

## image url are saved under src/crypto-birdz/pic-links.txt
use imgbb.com to upload those image files, get links


# Smart contract safety issues:
- math overflow/ underflow -> use safeMath
