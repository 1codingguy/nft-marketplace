// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

  // array to store NFTs
  string[] public kryptoBirdz;
  // if a fileName of a _kyrptoBird already exists
  mapping(string => bool) _kyrptoBirdExists;

  function mint(string memory _kryptoBird) public {
    // only mint if the _kryptoBird doesn't exist
    require(!_kyrptoBirdExists[_kryptoBird], 'Error - kryptoBird already exists.');
    // push the _kryptoBird instance into kryptoBirdz array
    kryptoBirdz.push(_kryptoBird);
    // generate the id form the length of kryptoBirdz array
    uint _id = kryptoBirdz.length - 1;
    // call the _mint() defined in ERC721.sol, to=msg.sender, tokenId=_id
    _mint(msg.sender, _id);
    // this instance of kyrptoBird already exists
    _kyrptoBirdExists[_kryptoBird] = true;

  }

  constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {}
}
