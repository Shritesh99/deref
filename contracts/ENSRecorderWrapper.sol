// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INameWrapper {
    function setSubnodeRecord(bytes32 parentNode, string memory label, address owner, address resolver, uint64 ttl, uint32 fuses, uint64 expire) external;
}
interface IResolver {
    function setText(bytes32 node, string memory key, string memory value) external;
    function setAddr(bytes32 node, address addr) external;
}

contract ENSRecorderWrapper {
    constructor() {
    }
    
    function setSubnodeRecord(address nameWrapper, bytes32 parentNode, string memory label, address owner, address resolver, uint64 ttl, uint32 fuses, uint64 expire) public {
        INameWrapper(nameWrapper).setSubnodeRecord(parentNode, label, owner, resolver, ttl, fuses, expire);
    }

    function setText(address ensNodeResolver, bytes32 node, string memory key, string memory value) public {
        IResolver(ensNodeResolver).setText(node, key, value);
    }

    function setAddr(address ensNodeResolver, bytes32 node, address addr) public {
        IResolver(ensNodeResolver).setAddr(node, addr);
    }
}