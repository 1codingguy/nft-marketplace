import React, { Component } from 'react'
import Web3 from 'web3'
import detectEthereumProvider from '@metamask/detect-provider'
import KryptoBird from '../abis/KryptoBird.json'
import {
  MDBCard,
  MDBCardBody,
  MDBCardTitle,
  MDBCardText,
  MDBCardImage,
  MDBBtn,
} from 'mdb-react-ui-kit'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)
    this.state = {
      account: '',
      contract: null,
      totalSupply: 0,
      kryptoBirdz: [],
    }
  }

  async componentDidMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  // first is to detect Ethereum provider
  async loadWeb3() {
    const provider = await detectEthereumProvider()

    if (provider) {
      console.log("there's a provider.")
      window.web3 = new Web3(provider)
      // console.log(window.web3)
      await window.ethereum.enable()
    } else {
      console.log('no provider')
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3
    const accounts = await web3.eth.requestAccounts()
    // only the first account form Ganache
    this.setState({ account: accounts[0] })

    const networkId = await web3.eth.net.getId()
    const networkData = KryptoBird.networks[networkId]
    // console.log(networkData)

    if (networkData) {
      const abi = KryptoBird.abi
      const address = networkData.address
      const contract = new web3.eth.Contract(abi, address)
      this.setState({ contract })

      // call the totalSupply, set it as state variable
      const totalSupply = await contract.methods.totalSupply().call()
      this.setState({ totalSupply })

      // this.state.kryptoBirdz array to keep track of tokens
      for (let i = 0; i < totalSupply; i++) {
        const KryptoBird = await contract.methods.kryptoBirdz(i).call()
        // how should we handle the state on the front end?
        this.setState({
          kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird],
        })
      }

      // console.log(this.state)
    } else {
      window.alert('smart contract not deployed.')
    }
  }

  // with minting we are sending information and we need to specify the account
  mint = kryptoBird => {
    this.state.contract.methods
      .mint(kryptoBird)
      .send({ from: this.state.account })
      .once('receipt', receipt => {
        this.setState({
          kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird],
        })
      })
  }

  render() {
    return (
      <div className='container-filled'>
        {console.log(this.state.kryptoBirdz)}
        <nav className='navbar navbar-dark fixed-top bg-dark flex-md-wrap p-0 shadow'>
          <div
            className='navbar-brand col-sm-3 col-md-2 mr-0'
            style={{ color: 'white' }}
          >
            CryptoBird NFTs Marketplace
          </div>
          <ul className='navbar-nav px-3'>
            <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
              <small className='text-white'>{this.state.account}</small>
            </li>
          </ul>
        </nav>

        <div className='container-fluid mt-1'>
          <div className='row'>
            <main role='main' className='col-lg-12 d-flex text-center'>
              <div
                className='content mr-auto ml-auto'
                style={{ opacity: '0.8' }}
              >
                <h1 style={{ color: 'white' }}>
                  CryptoBird - NFT marketplace
                </h1>
                <form
                  onSubmit={event => {
                    event.preventDefault()
                    const kryptoBird = this.kryptoBird.value
                    console.log(kryptoBird)
                    this.mint(kryptoBird)
                  }}
                >
                  <input
                    type='text'
                    placeholder='Add a file location'
                    className='form-control mb-1'
                    ref={input => (this.kryptoBird = input)}
                  />
                  <input
                    style={{ margin: '6px' }}
                    type='submit'
                    className='btn btn-primary btn-black'
                    value='MINT'
                  />
                </form>
              </div>
            </main>
          </div>
          <hr />

          <div className='row textCenter '>
            {this.state.kryptoBirdz.map((kryptoBird, i) => {
              return (
                <div>
                  <div>
                    <MDBCard
                      className='token img'
                      style={{ maxWidth: '22rem' }}
                    >
                      <MDBCardImage
                        src={kryptoBird}
                        position='top'
                        height='250rem'
                        style={{ marginRight: '4px' }}
                      />
                      <MDBCardBody>
                        <MDBCardTitle>KryptoBirdz</MDBCardTitle>
                        <MDBCardText>
                          KryptoBirdz description text here.
                        </MDBCardText>
                        <MDBBtn href={kryptoBird}>Download</MDBBtn>
                      </MDBCardBody>
                    </MDBCard>
                  </div>
                </div>
              )
            })}
          </div>
        </div>
      </div>
    )
  }
}

export default App
