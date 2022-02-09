const { assert } = require('chai')

const KryptoBird = artifacts.require('KryptoBird')

// check for chai
require('chai').use(require('chai-as-promised')).should()

contract(KryptoBird, accounts => {
  let contract

  // before tells our test to run this first before anything else
  before(async () => {
    contract = await KryptoBird.deployed()
  })

  // testing container - describe

  describe('deployment', async () => {
    // test sample with writing it
    it('deploy successfully', async () => {
      const address = await contract.address
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
      assert.notEqual(address, 0x0)
    })

    it('display the correct name', async () => {
      const name = await contract.name()
      assert.equal(name, 'KryptoBird')
    })

    it('display the correct symbol', async () => {
      const symbol = await contract.symbol()
      assert.equal(symbol, 'KBIRDZ')
    })
  })

  describe('minting', async () => {
    it('creates a new token', async () => {
      const result = await contract.mint('https...1')
      const totalSupply = await contract.totalSupply()

      // testing for case of success

      console.log(totalSupply)
      console.log(totalSupply.words)
      console.log(totalSupply.words[0])
      
      assert.equal(totalSupply.words[0], 1)

      const event = result.logs[0].args
      assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'event.from is the contract')
      assert.equal(event._to, accounts[0], 'event.to is msg.sender')

      // testing for case of failure
      await contract.mint('https...1').should.be.rejected
    })
  })
})
