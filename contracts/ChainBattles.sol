// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct levels {
        uint256 expLevel;
        uint256 hitPoints;
        uint256 manaPoints;
        uint256 damage;
        uint256 critDmg;
        
    }

    mapping(uint256 => levels) public tokenIdToLevels;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
        
    }
    
    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: cyan; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="goldenrod" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"Experience: ", getExp(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"HP: ", getHitPoints(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"Mana: ", getMana(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"Damage: ", getDamage(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"Crit DMG: ", getCritDmg(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}

function getExp(uint256 tokenId) public view returns (string memory) {
    uint256 exp = tokenIdToLevels[tokenId].expLevel;
    return exp.toString();
}

function getHitPoints(uint256 tokenId) public view returns (string memory) {
    uint256 hp = tokenIdToLevels[tokenId].hitPoints;
    return hp.toString();
}

function getMana(uint256 tokenId) public view returns (string memory) {
    uint256 mana = tokenIdToLevels[tokenId].manaPoints;
    return mana.toString();
}

function getDamage(uint256 tokenId) public view returns (string memory) {
    uint256 dmg = tokenIdToLevels[tokenId].damage;
    return dmg.toString();
}

function getCritDmg(uint256 tokenId) public view returns (string memory) {
    uint256 crit = tokenIdToLevels[tokenId].critDmg;
    return crit.toString();
}

function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    tokenIdToLevels[newItemId].expLevel = 1;
    tokenIdToLevels[newItemId].hitPoints = 100 + (random() % 400);
    tokenIdToLevels[newItemId].manaPoints = 75 + (random() % 300);
    tokenIdToLevels[newItemId].damage = 50 + (random() % 500);
    tokenIdToLevels[newItemId].critDmg = 50 + (random() % 1500);
    _setTokenURI(newItemId, getTokenURI(newItemId));
}

function random() private view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
}

function train(uint256 tokenId) public {
    require(_exists(tokenId), "Please use an existing token");
    require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
    uint256 currentExp = tokenIdToLevels[tokenId].expLevel;
    tokenIdToLevels[tokenId].expLevel = currentExp += 1;
    uint256 currentHP = tokenIdToLevels[tokenId].hitPoints;
    tokenIdToLevels[tokenId].hitPoints = currentHP += 25;
    uint256 currentMP = tokenIdToLevels[tokenId].manaPoints;
    tokenIdToLevels[tokenId].manaPoints = currentMP += 15;
    uint256 currentDmg = tokenIdToLevels[tokenId].damage;
    tokenIdToLevels[tokenId].damage = currentDmg += 30;
    uint256 currentCrit = tokenIdToLevels[tokenId].critDmg;
    tokenIdToLevels[tokenId].critDmg = currentCrit += 50;
    _setTokenURI(tokenId, getTokenURI(tokenId));
}


}