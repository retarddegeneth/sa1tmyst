// Sa1tMyst — mechanic mystery wrapper for sa1t v2
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sa1tMyst {
    struct MysteryToken {
        bytes32 mechanicHash;
        string salt;
        string mechanic;
        bool revealed;
        address creator;
        uint256 createdAt;
        uint256 revealedAt;
    }

    mapping(address => MysteryToken) public mysteryTokens;
    address public immutable owner;

    event MysteryRegistered(address indexed pool, bytes32 mechanicHash, address creator, uint256 timestamp);
    event Revealed(address indexed pool, string mechanic, address revealer, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Sa1tMyst: not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register an existing sa1t v2 pool as a mystery token
    /// @param pool The sa1t v2 pool address
    /// @param mechanicHash keccak256(abi.encodePacked(mechanic, salt))
    /// @param salt The random salt used in hash
    function registerMystery(
        address pool,
        bytes32 mechanicHash,
        string calldata salt
    ) external {
        require(pool != address(0), "Sa1tMyst: zero pool");
        require(mechanicHash != bytes32(0), "Sa1tMyst: zero hash");
        require(mysteryTokens[pool].createdAt == 0, "Sa1tMyst: already registered");

        mysteryTokens[pool] = MysteryToken({
            mechanicHash: mechanicHash,
            salt: salt,
            mechanic: "",
            revealed: false,
            creator: msg.sender,
            createdAt: block.timestamp,
            revealedAt: 0
        });

        emit MysteryRegistered(pool, mechanicHash, msg.sender, block.timestamp);
    }

    /// @notice Reveal the mechanic for a mystery pool
    /// @param pool The sa1t v2 pool address
    /// @param mechanic The mechanic string or bitmask that was committed
    function reveal(address pool, string calldata mechanic) external {
        MysteryToken storage mt = mysteryTokens[pool];
        require(mt.createdAt > 0, "Sa1tMyst: not mystery");
        require(!mt.revealed, "Sa1tMyst: already revealed");

        // Verify mechanic + salt matches committed hash
        bytes32 computed = keccak256(abi.encodePacked(mechanic, mt.salt));
        require(computed == mt.mechanicHash, "Sa1tMyst: wrong mechanic");

        mt.mechanic = mechanic;
        mt.revealed = true;
        mt.revealedAt = block.timestamp;

        emit Revealed(pool, mechanic, msg.sender, block.timestamp);
    }

    /// @notice Batch reveal multiple mechanics at once (for combo launches)
    function revealCombo(
        address pool,
        string calldata mechanicPart1,
        string calldata mechanicPart2,
        string calldata mechanicPart3,
        string calldata mechanicPart4
    ) external {
        // Build combined mechanic string: "1,3,7" style
        string memory combined = "";
        if (bytes(mechanicPart1).length > 0) {
            combined = mechanicPart1;
        }
        if (bytes(mechanicPart2).length > 0) {
            combined = combined.length > 0 ? string(abi.encodePacked(combined, ",", mechanicPart2)) : mechanicPart2;
        }
        if (bytes(mechanicPart3).length > 0) {
            combined = combined.length > 0 ? string(abi.encodePacked(combined, ",", mechanicPart3)) : mechanicPart3;
        }
        if (bytes(mechanicPart4).length > 0) {
            combined = combined.length > 0 ? string(abi.encodePacked(combined, ",", mechanicPart4)) : mechanicPart4;
        }

        reveal(pool, combined);
    }

    /// @notice Get mystery token data
    function getMystery(address pool) external view returns (MysteryToken memory) {
        return mysteryTokens[pool];
    }

    /// @notice Check if a pool is a registered mystery token
    function isMystery(address pool) external view returns (bool) {
        return mysteryTokens[pool].createdAt > 0;
    }

    /// @notice Check if a mystery pool has been revealed
    function isRevealed(address pool) external view returns (bool) {
        return mysteryTokens[pool].revealed;
    }

    /// @notice Owner can update factory or perform emergency ops
    function updateOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Sa1tMyst: zero owner");
        // Use a proxy pattern or just redeploy for hackathon simplicity
        // For now, no state migration — redeploy if owner changes
    }
}
