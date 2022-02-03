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

