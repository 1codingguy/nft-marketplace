// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable {
  uint256[] private _allTokens;

  // tokenId to position in _allTokens array
  // better name: whereIsEachTokenStoredInAllTokensArray
  mapping(uint256 => uint256) private _allTokensIndex;

  // owner to list of all tokenIds owned
  // no need to init empty array for each entry?
  // better name: whoOwnWhatTokens
  mapping(address => uint256[]) private _ownedTokens;

  // tokenId to index of the owner tokens list
  // more explainitory name: whichTokenRefersToWhatIndexInOwnedTokens
  mapping(uint256 => uint256) private _ownedTokensIndex;

  constructor() {
    _registerInterface(
      bytes4(
        keccak256('totalSupply(bytes4)') ^
          keccak256('tokenByIndex(bytes4)') ^
          keccak256('tokenOfOwnerByIndex(bytes4)')
      )
    );
  }

  // returns the total supply from the _allTokens array
  function totalSupply() external view override returns (uint256) {
    return _allTokens.length;
  }

  // better name: getTokenByIndex()
  function tokenByIndex(uint256 index) public view override returns (uint256) {
    // guard clause to make sure index is not out of bound
    // if calling totalSupply in the require statement it causes an error, says it's not yet visible?
    // but calling it with this.totalSupply() works
    require(index <= this.totalSupply());
    return _allTokens[index];
  }

  //
  function tokenOfOwnerByIndex(address ownerAddress, uint256 index)
    public
    view
    override
    returns (uint256)
  {
    // I reckon this require line will break because balanceOf() doesn't return a number but an object
    // needs to use .then() to get the balanceInstance but not sure how to do it currently
    require(index <= this.balanceOf(ownerAddress));
    return _ownedTokens[ownerAddress][index];
  }

  function _mint(address to, uint256 tokenId) internal override(ERC721) {
    // call_mint() from parent class, which is ERC721 in this case
    super._mint(to, tokenId);
    // add tokens to our totalSupply
    _addTokensToAllTokenEnumeration(tokenId);

    // add tokens to the owner
    _addTokensToOwnerEnumeration(to, tokenId);
  }

  function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
    _allTokensIndex[tokenId] = _allTokens.length;
    _allTokens.push(tokenId);
  }

  function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
    // add address and tokenId to the _ownedTokens
    _ownedTokens[to].push(tokenId);
    // ownedTokensIndex tokenId set to address of the ownedToken position
    _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
  }
}
