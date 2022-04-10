const {ethers} = require("hardhat");

async function main() {
  const SuperMarioNFT = await ethers.getContractFactory("SuperMario1155");
  const nftInstance = await SuperMarioNFT.deploy("SuperCollection", "SCN");
  await nftInstance.deployed();
  console.log("contract was deployed to:", nftInstance.address);

  await nftInstance.mint(10, "https://ipfs.io/ipfs/QmRHKNBfgc7jPJxVFZzib8RLCkiSfgRVX2teEUCvFfXuFp");
  console.log("NFT successfully minted");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
