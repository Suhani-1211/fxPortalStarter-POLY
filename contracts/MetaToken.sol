// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomNFT is ERC721Enumerable, Ownable {
    uint256 public mintCount;
    mapping(uint256 => string) private _tokenMetadata;
    mapping(uint256 => string) private _tokenDescriptions;

    // Constructor initializing the NFT collection with a name and symbol
    constructor() ERC721("Custom Collection", "CCNFT") {
        mintCount = 0;
    }

    // Function to mint multiple NFTs with metadata and descriptions
    function mintBatch(string[] memory metadataURIs, string[] memory descriptions) external onlyOwner {
        require(metadataURIs.length == descriptions.length, "Metadata and description arrays must be of equal length");

        uint256 currentSupply = totalSupply();
        uint256 mintAmount = metadataURIs.length;

        // Mint the NFTs and assign metadata and descriptions
        for (uint256 i = 0; i < mintAmount; i++) {
            uint256 tokenId = currentSupply + i;
            _safeMint(msg.sender, tokenId);
            _tokenMetadata[tokenId] = metadataURIs[i];
            _tokenDescriptions[tokenId] = descriptions[i];
        }

        mintCount += mintAmount;
    }

    // Function to return the description of a given token ID
    function getDescription(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "Description query for nonexistent token");
        return _tokenDescriptions[tokenId];
    }

    // Function to get the metadata URI of a given token ID
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenMetadata[tokenId];
    }
    
    // Function to burn an NFT, removing it from supply
    function burnNFT(uint256 tokenId) external onlyOwner {
        require(_exists(tokenId), "Burn query for nonexistent token");
        _burn(tokenId);
        delete _tokenMetadata[tokenId];
        delete _tokenDescriptions[tokenId];
    }
}
