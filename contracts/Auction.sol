pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction {
	// todo: add state variables as necessary

	constructor(uint _houseFee, uint _maxAuctionLength) {
		// todo: finish this
	}

	// gets the amount a person has bid on an auction
	function getBid(uint _auctionId, address _bidder) public view returns (uint) {
		// todo: finish this
	}

	// gets the current highest bid on an auction
	function getHighestBid(uint _auctionId) public view returns (uint) {
		// todo: finish this
}

	// startAuction starts an auction for a given NFT
	// it should verify the NFT is owned by the caller
	function startAuction(address _nftContract, uint _nftId, uint _auctionLength, uint _minBid) public returns (uint) {
	
		// note: this connects this contract to the NFT contract
		// this allows us to call methods on the NFT contract
    		IERC721 nftContractInstance = IERC721(_nftContract);
    	
		// todo: finish this
	}
    
	// bid submits a bid for a given auction
	// this should only allow a bid to be submitted if it’s higher than the minimum bid
	function bid(uint _auctionId) public payable returns (uint) {
		// todo: finish this
    	}
    
	// claim allows a user to claim their money back if they are not the winner of an auction
	function claim(uint _auctionId) public returns (uint) {
    		// todo: finish this
	}

	// endAuction ends an auction and pays out the winner
	function endAuction(uint _auctionId) public returns (uint) {
    		// todo: finish this
		// note: you will have to connect to the NFT contract again
	}    	
}
