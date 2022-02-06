// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ERC721Metadata {
  string private _name;
  string private _symbol;

  constructor(string memory name, string memory symbolified) {
    _name = name;
    _symbol = symbolified;
  }

  function getName() external view returns (string memory) {
    return _name;
  }

  function getSymbol() external view returns (string memory) {
    return _symbol;
  }
}
