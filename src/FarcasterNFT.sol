// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FarcasterNFT is ERC721 {
    address public immutable creator;
    string public constant BASE_URI = "https://styled-nfts.kasra.codes/tokens/";
    uint256 public currentTokenId;
    
    constructor() ERC721("Farcaster NFT", "FNFT") {
        creator = msg.sender;
    }

    function mint() public payable returns (uint256) {
        require(msg.value == 0.0025 ether, "Must send exactly 0.0025 ETH");
        
        // Send payment directly to creator before minting
        (bool success, ) = payable(creator).call{value: msg.value}("");
        require(success, "Transfer failed");
        
        uint256 tokenId = currentTokenId;
        _mint(msg.sender, tokenId);
        currentTokenId = tokenId + 1;
        
        return tokenId;
    }

    function _baseURI() internal pure virtual override returns (string memory) {
        return BASE_URI;
    }
}