pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction {
	// todo: add state variables as necessary

    uint public houseFee;

    address payable public owner;

    uint public maxAucLength;

    uint public maxAucID;

    struct AucInfo {
        // set auction duration
        uint aucLength;

        // min bid amount 
        uint startingBid;

        // end time
        uint endTime;

        // current max bid
        uint highBid;

        // nft being auctioned
        uint nftId;

        // nft address
        address nftContract;

        // track all bids
        mapping (address => uint) bids;

        // keep track of all addresses of bidders
        address[] bidders;

        // track the winner 
        address payable winner;
    }

    // track the info for each auction
    mapping(uint => AucInfo) public aucInfos;

    // when a new auction is created
    event startAuc(uint aucID, uint aucLength, uint maxBid, uint endTime);

    // when a new bid is made
    event Bid(address bidder, uint amount);

    // when someone wins the auction
    event EndGame(uint aucID, uint highBid, address winner);

	constructor(uint _houseFee, uint _maxAuctionLength) {
		// todo: finish this

        require(_houseFee <= 100, "house fee must be less than or equal to 100");

        // if the deployer owns the contract 
        owner = payable(msg.sender);
        houseFee = _houseFee;
        maxAucLength = _maxAuctionLength;
	}

	// gets the amount a person has bid on an auction
	function getBid(uint _auctionId, address _bidder) public view returns (uint) {
		// todo: finish this
        require(_auctionId > 0, "auction does not exist");
        require(_auctionId <= maxAucID, "auction does not exist");

        return aucInfos[_auctionId].bids[_bidder];
    }

	// gets the current highest bid on an auction
	function getHighestBid(uint _auctionId) public view returns (uint) {
		// todo: finish this
        require(_auctionId > 0, "auction does not exist");
        require(_auctionId <= maxAucID, "auction does not exist");

        return aucInfos[_auctionId].highBid;
    }

	// startAuction starts an auction for a given NFT
	// it should verify the NFT is owned by the caller
	function startAuction(address _nftContract, uint _nftId, uint _auctionLength, uint _minBid) public returns (uint) {
	
		// note: this connects this contract to the NFT contract
		// this allows us to call methods on the NFT contract
    	IERC721 nftContractInstance = IERC721(_nftContract);
    	
		// todo: finish this
        require(nftContractInstance.ownerOf(_nftId) == msg.sender);

        require(_minBid >= 0, "auction must have a non-negative starting bid");

        maxAucID++;
        aucInfos[maxAucID].aucLength = _auctionLength;
        aucInfos[maxAucID].highBid = _minBid - 1; 
        aucInfos[maxAucID].startingBid = _minBid;
        aucInfos[maxAucID].endTime = block.timestamp + _auctionLength;
        aucInfos[maxAucID].nftContract = _nftContract;
        aucInfos[maxAucID].nftId = _nftId;

        // contract holds the NFT during the auction
        nftContractInstance.safeTransferFrom(msg.sender, _nftContract, _nftId);

        emit startAuc(maxAucID, _auctionLength, _minBid - 1, aucInfos[maxAucID].endTime);

        return maxAucID;
	}
    
	// bid submits a bid for a given auction
	// this should only allow a bid to be submitted if it’s higher than the minimum bid
	function bid(uint _auctionId) public payable returns (uint) {
		// todo: finish this
        require(_auctionId > 0, "auction does not exist");
        require(_auctionId <= maxAucID, "auction does not exist");
        require(msg.value > aucInfos[_auctionId].startingBid, "bid must be greater than min value");
        require(block.timestamp < aucInfos[_auctionId].endTime, "auction must still be ongoing");

        uint currentBid = aucInfos[_auctionId].bids[msg.sender];
        uint newBid = currentBid + msg.value;

        require(newBid > aucInfos[_auctionId].highBid); // can't be less than current bid

        if (currentBid == 0) {
            aucInfos[_auctionId].bidders.push(msg.sender);
        }

        aucInfos[_auctionId].bids[msg.sender] = msg.value;
        aucInfos[_auctionId].highBid = msg.value;

        emit Bid(msg.sender, msg.value);

        return aucInfos[_auctionId].bids[msg.sender];
    	}
    
	// claim allows a user to claim their money back if they are not the winner of an auction
	function claim(uint _auctionId) public returns (uint) {
    	// todo: finish this
        require(_auctionId > 0, "auction does not exist");
        require(_auctionId <= maxAucID, "auction does not exist");
        require(aucInfos[_auctionId].endTime >= block.timestamp, "auction hasn't ended");

        // caller should access their bid amount and have it transferred back
        uint callerBid = getBid(_auctionId, msg.sender);
        return callerBid;
	}

    function chooseWinner(uint _auctionId) internal view returns (address payable) {

        uint currBid = 0;

        for (uint i = 0; i < aucInfos[_auctionId].bidders.length; i++) {
            currBid = aucInfos[_auctionId].bids[aucInfos[_auctionId].bidders[i]];
            if (currBid == aucInfos[_auctionId].highBid) {
                return payable(aucInfos[_auctionId].bidders[i]);
            }
        }

        revert("no winner found");
    }

    function claimNFT(uint _auctionId, address _nftContract, uint _nftId) public returns (address payable) {
        IERC721 nftContractInstance = IERC721(_nftContract);
        
        require(_auctionId > 0);
        require(_auctionId <= maxAucID);
        require(aucInfos[_auctionId].endTime >= block.timestamp);
        require(msg.sender == chooseWinner(_auctionId));
        
        nftContractInstance.safeTransferFrom(_nftContract, msg.sender, _nftId);
        return payable(_nftContract);
    }

	// endAuction ends an auction and pays out the winner
	function endAuction(uint _auctionId) public returns (uint) {
    	// todo: finish this
		// note: you will have to connect to the NFT contract again
        require(_auctionId > 0);
        require(_auctionId <= maxAucID);
        require(aucInfos[_auctionId].endTime >= block.timestamp);

        address nftContract = aucInfos[_auctionId].nftContract;
        uint nftId = aucInfos[_auctionId].nftId;
        IERC721 nftContractInstance = IERC721(nftContract);

        // if no bid was placed transfer NFT back to auction starter
        if (aucInfos[_auctionId].highBid < aucInfos[_auctionId].startingBid) {
            nftContractInstance.safeTransferFrom(nftContract, msg.sender, nftId);
        }

        // find the highest bidder
        aucInfos[_auctionId].winner = chooseWinner(_auctionId);

        // payout
        uint fee = (houseFee * aucInfos[_auctionId].highBid) / 100;
        uint winningBid = aucInfos[_auctionId].highBid;
        uint payment = winningBid - fee;

        aucInfos[_auctionId].winner.transfer(payment);
        owner.transfer(fee);

        emit EndGame(_auctionId, winningBid, aucInfos[_auctionId].winner);

        return (payment);
	}    	
}
