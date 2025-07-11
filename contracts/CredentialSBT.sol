// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Credential Soulbound Token (gabungan Registry + Minter)
contract CredentialSBT {
    enum Status { Invalid, Valid, Revoked }

    struct Credential {
        address issuer;
        bytes32 metaHash;
        uint256 expiry;
        Status status;
    }

    string public name = "SoulboundCredential";
    string public symbol = "SBC";

    address public validator;
    address public issuer;
    uint256 private tokenIdCounter;

    mapping(uint256 => Credential) public registry;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _ownedToken;
    mapping(uint256 => string) private _tokenURIs;

    event CredentialRegistered(uint256 tokenId, address issuer, bytes32 metaHash, uint256 expiry);
    event CredentialRevoked(uint256 tokenId);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    modifier onlyValidator() {
        require(msg.sender == validator, "Not authorized (validator only)");
        _;
    }

    modifier onlyIssuer() {
        require(msg.sender == issuer, "Not authorized (issuer only)");
        _;
    }

    constructor() {
        validator = msg.sender;
        issuer = msg.sender;
    }

    function attestAndMint(
        address to,
        string memory credType,
        uint256 issueDate,
        uint256 expiry,
        string memory uri
    ) public onlyIssuer returns (uint256) {
        require(to != address(0), "Invalid subject address");
        require(bytes(credType).length > 0 && issueDate > 0, "Invalid input");
        require(expiry == 0 || expiry > block.timestamp - 60, "Already expired");
        require(_ownedToken[to] == 0, "Address already has a credential");

        bytes32 metaHash = keccak256(abi.encodePacked(issuer, to, credType, issueDate));

        tokenIdCounter++;
        uint256 tokenId = tokenIdCounter;

        registry[tokenId] = Credential({
            issuer: issuer,
            metaHash: metaHash,
            expiry: expiry,
            status: Status.Valid
        });

        _owners[tokenId] = to;
        _ownedToken[to] = tokenId;
        _tokenURIs[tokenId] = uri;

        emit CredentialRegistered(tokenId, issuer, metaHash, expiry);
        emit Transfer(address(0), to, tokenId);

        return tokenId;
    }

    function revoke(uint256 tokenId) public onlyValidator {
        registry[tokenId].status = Status.Revoked;
        emit CredentialRevoked(tokenId);
    }

    function burn() public {
        uint256 tokenId = _ownedToken[msg.sender];
        require(tokenId != 0, "No token to burn");

        delete _owners[tokenId];
        delete _tokenURIs[tokenId];
        delete _ownedToken[msg.sender];
        registry[tokenId].status = Status.Revoked;

        emit Transfer(msg.sender, address(0), tokenId);
    }

    function isValid(uint256 tokenId) public view returns (bool) {
        Credential memory c = registry[tokenId];
        return c.status == Status.Valid && (c.expiry == 0 || c.expiry > block.timestamp);
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return _owners[tokenId];
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function getCredentialInfo(uint256 tokenId) public view returns (Credential memory) {
        return registry[tokenId];
    }

    function transferFrom(address, address, uint256) public pure {
        revert("SBT is non-transferable");
    }
}

