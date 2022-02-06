// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/*
  What does a mint function do?
  - keep track of the address
  - keep track of the tokenIds
  - who has which NFT, which address is mapped to which tokenId
  - how many NFT that person has
  - create en event that emit a transfer log
    - contract address
    - where it is being minted to 
    - tokenId
  
   */

contract ERC721 {
  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  // which tokenId belongs to which owner
  mapping(uint256 => address) private _tokenOwner;
  // how many tokens each owner has
  mapping(address => uint256) private _ownedTokenCount;

  function _exist(uint256 tokenId) internal view returns (bool) {
    // setting the address of NFT owner, check the mapping
    address owner = _tokenOwner[tokenId];
    // returns true if that tokenId is mapped to an owner (address isn't zero)
    return owner != address(0);
  }

  function _mint(address to, uint256 tokenId) internal {
    // requires the address isn't zero
    require(to != address(0), 'ERC721: minting to the zero address.');
    // requires the token has not already been minted
    require(!_exist(tokenId), 'ERC721: token already existed.');
    // set the _tokenOwner of the tokenId to the address argument to
    _tokenOwner[tokenId] = to;
    // increase the count of that owner
    _ownedTokenCount[to]++;
    // emit the event
    emit Transfer(address(0), to, tokenId);
  }

  function balanceOf(address _owner) public view returns (uint256){
    require(_owner != address(0), "ERC721: can't query the balance of zero address");
    return _ownedTokenCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address){
    address owner = _tokenOwner[_tokenId];
    require(owner != address(0), "ERC721: zero address for this tokenId");
    return owner;
  }
}
