import {
    time,
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
  
describe("PennFT", function () {
  let PennFT, pennFT, owner, addr1, addr2;

  beforeEach(async function () {
      PennFT = await ethers.getContractFactory("PennFT");
      [owner, addr1, addr2] = await ethers.getSigners();
      pennFT = await PennFT.deploy();
  })

  describe("Minting", function() {
    it("Should mint a new NFT", async function () {
      await pennFT.MintNFT(addr1.address, "https://example.com/token/1");
      expect(await pennFT.ownerOf(0)).to.equal(addr1.address);
      expect(await pennFT.tokenURI(0)).to.equal("https://example.com/token/1");
    });

    it("Should only allow the owner to mint", async function () {
      await expect(pennFT.connect(addr1).MintNFT(addr1.address, "https://example.com/token/1"))
        .to.be.rejectedWith("Ownable: caller is not the owner");
    });
  })

  describe("Transferring", function () {
    it("Should transfer ownership of the NFT", async function () {
      await pennFT.MintNFT(addr1.address, "https://example.com/token/1");
      await pennFT.connect(addr1).transferFrom(addr1.address, addr2.address, 0);
      expect(await pennFT.ownerOf(0)).to.equal(addr2.address);
    });
  })

  describe("Approval", function () {
    it("Should approve and then transfer an NFT when the approved address calls", async function () {
      await pennFT.MintNFT(addr1.address, "https://example.com/token/1");
      await pennFT.connect(addr1).approve(addr2.address, 0);
      expect(await pennFT.isApprovedForAll(addr1.address, addr2.address)).to.be.false;
      await pennFT.connect(addr2).transferFrom(addr1.address, addr2.address, 0);
      expect(await pennFT.ownerOf(0)).to.equal(addr2.address);
    });

    it("Should approve all NFTs for a given address", async function () {
      await pennFT.MintNFT(addr1.address, "https://example.com/token/1");
      await pennFT.connect(addr1).setApprovalForAll(addr2.address, true);
      expect(await pennFT.isApprovedForAll(addr1.address, addr2.address)).to.be.true;
      await pennFT.connect(addr2).transferFrom(addr1.address, addr2.address, 0);
      expect(await pennFT.ownerOf(0)).to.equal(addr2.address);
    });
  });

});

  