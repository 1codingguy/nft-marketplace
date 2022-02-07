// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {

  uint256[] private _allTokens;

  // tokenId to position in _allTokens array
  mapping(uint256 => uint256) private _allTokensIndex;

  // owner to list of all tokenIds owned 
  mapping(address => uint256[]) private _ownedTokens;

  // tokenId index of the owner tokens list
  mapping(uint256 => uint256) private _ownedTokensIndex;

  function totalSupply() external view returns(uint256){
    return _allTokens.length;
  }


  function _mint(address to, uint256 tokenId) internal override(ERC721) {
    super._mint(to, tokenId);
  }
}