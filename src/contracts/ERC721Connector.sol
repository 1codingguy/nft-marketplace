// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721Metadata.sol';
import './ERC721Enumerable.sol';

// ERC721Enumerable already inherit from ERC721, no need for double inheritance
// in new version of compiler such double inheritance is prohibited
contract ERC721Connector is ERC721Metadata, ERC721Enumerable {

  constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) {

  }
}
