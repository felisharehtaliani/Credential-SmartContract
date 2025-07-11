// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Verifier contract for CredentialSBT
interface ICredentialSBT {
    enum Status { Invalid, Valid, Revoked }

    function isValid(uint256 tokenId) external view returns (bool);
    function ownerOf(uint256 tokenId) external view returns (address);
    function tokenURI(uint256 tokenId) external view returns (string memory);
    function getCredentialInfo(uint256 tokenId) external view returns (
        address issuer,
        bytes32 metaHash,
        uint256 expiry,
        Status status
    );
}

contract Verifier {
    ICredentialSBT public credentialSBT;

    constructor(address credentialSBTAddress) {
        credentialSBT = ICredentialSBT(credentialSBTAddress);
    }

    function verify(uint256 tokenId) public view returns (bool) {
        return credentialSBT.isValid(tokenId);
    }

    function checkExpiry(uint256 tokenId) public view returns (uint256) {
        (, , uint256 expiry, ) = credentialSBT.getCredentialInfo(tokenId);
        return expiry;
    }

    function getOwner(uint256 tokenId) public view returns (address) {
        return credentialSBT.ownerOf(tokenId);
    }

    function getMetadataURI(uint256 tokenId) public view returns (string memory) {
        return credentialSBT.tokenURI(tokenId);
    }

    function getStatus(uint256 tokenId) public view returns (ICredentialSBT.Status) {
        (, , , ICredentialSBT.Status status) = credentialSBT.getCredentialInfo(tokenId);
        return status;
    }

    function getMetaHash(uint256 tokenId) public view returns (bytes32) {
        (, bytes32 metaHash, , ) = credentialSBT.getCredentialInfo(tokenId);
        return metaHash;
    }
}
