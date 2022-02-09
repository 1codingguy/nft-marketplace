// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

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

contract ERC721 is ERC165, IERC721 {
  // which tokenId belongs to which owner
  mapping(uint256 => address) private _tokenOwner;
  // how many tokens each owner has
  mapping(address => uint256) private _ownedTokenCount;
  // tokenId to approved address
  mapping(uint256 => address) private _tokenApprovals;

  constructor() {
    _registerInterface(
      bytes4(
        keccak256('balanceOf(bytes4)') ^
          keccak256('ownerOf(bytes4)') ^
          keccak256('transferFrom(bytes4)')
      )
    );
  }

  function _exist(uint256 tokenId) internal view returns (bool) {
    // setting the address of NFT owner, check the mapping
    address owner = _tokenOwner[tokenId];
    // returns true if that tokenId is mapped to an owner (address isn't zero)
    return owner != address(0);
  }

  function _mint(address to, uint256 tokenId) internal virtual {
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

  function balanceOf(address _owner) public view override returns (uint256) {
    require(
      _owner != address(0),
      "ERC721: can't query the balance of zero address"
    );
    return _ownedTokenCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view override returns (address) {
    address owner = _tokenOwner[_tokenId];
    require(owner != address(0), 'ERC721: zero address for this tokenId');
    return owner;
  }

  function _transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal {
    require(_to != address(0), 'Error: Cannot transfer to the zero address');
    require(
      ownerOf(_tokenId) == _from,
      'Error: Cannot transfer a token not owned by you!'
    );
    // decerement the token from the person transfer out
    _ownedTokenCount[_from]--;
    // increment the token for the person tranfer to
    _ownedTokenCount[_to]++;
    // assign token to new owner
    _tokenOwner[_tokenId] = _to;

    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) public override {
    require(isApprovedOrOwner(msg.sender, _tokenId));
    _transferFrom(_from, _to, _tokenId);
  }

  function approve(address _to, uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    // require the person approving is the actual owner of the token
    require(
      owner == msg.sender,
      'Error: current caller does not own the token'
    );
    // require we can't send token from the owner to the owner himself (current caller)
    require(owner != _to, 'Error: caller cannot send the token to himself');
    // update the map of the approval addresses
    _tokenApprovals[tokenId] = _to;
    // approving an address to a tokenId
    emit Approval(msg.sender, _to, tokenId);
  }

  function isApprovedOrOwner(address spender, uint256 tokenId)
    internal
    view
    returns (bool)
  {
    require(_exist(tokenId));
    address owner = ownerOf(tokenId);
    return (spender == owner);
    // return (spender == owner || getApproved(tokenId) == spender );
  }
}
