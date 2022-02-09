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

  // each describe is a test container

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
      const event = result.logs[0].args
      const totalSupply = await contract.totalSupply()

      // testing for case of successful minting
      assert.equal(totalSupply.words[0], 1)
      assert.equal(
        event._from,
        '0x0000000000000000000000000000000000000000',
        'event.from is the contract'
      )
      assert.equal(event._to, accounts[0], 'event.to is msg.sender')

      // testing for case of failure
      await contract.mint('https...1').should.be.rejected
    })
  })

  describe('indexing', async () => {
    it('mints 4 KryptoBirdz in total', async () => {
      await contract.mint('https...2')
      await contract.mint('https...3')
      await contract.mint('https...4')
      const totalSupply = await contract.totalSupply()
      // assert.equal(totalSupply.words[0], 4)

      // loop through list and grab KBirdz from list
      let result = []

      for (let i = 0; i < totalSupply; i++) {
        result.push(await contract.kryptoBirdz(i))
      }
      // assert that our new array result will equal our expected result
      // console.log(result)
      const expectedResult = [
        'https...1',
        'https...2',
        'https...3',
        'https...4',
      ]
      assert.equal(result.join(''), expectedResult.join(''))
    })
  })
})
