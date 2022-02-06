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

console command always typed in:
kyrptoBird = await KryptoBird.deployed()
kyrptoBird.getName()
  - check if able to access getter function

kyrptoBird.mint('1st')
kyrptoBird.mint('2nd')
kyrptoBird.mint("http...1")
kyrptoBird.mint("http...2")

kyrptoBird.balanceOf("0x29c8dB5729431c43D7Dde7ABC60aC5294f39E9F6").then(function(balance) {balanceInstance = balance})

kyrptoBird.ownerOf(0)

# write balanceOf() ourself that adhere to the ERC721 standard

## seems "zero" address is something special?
- there is this `address(0)` thing to check if the address is zero in tutorial