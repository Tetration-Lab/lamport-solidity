// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Lamport} from "../src/Lamport.sol";

contract LamportFull {
    function verify(
        bytes32 pkHash,
        bytes32[512] memory pks,
        bytes32[256] memory sigs,
        bytes32 msgHash
    ) public {
        Lamport.verify(pkHash, pks, sigs, msgHash);
    }
}

contract LamportTest is Test {
    LamportFull flp;
    function setUp() public {
        flp = new LamportFull();
    }
    function test_verify_0() public {
        bytes32[512] memory pks;
        for (uint256 i = 0; i < 512; i++) {
            pks[i] = keccak256(abi.encodePacked(i));
        }
        bytes32 pkHash = keccak256(abi.encodePacked(pks));
        bytes32 msgHash = 0x0;
        bytes32[256] memory sigs;
        for (uint256 i = 0; i < 256; i++) {
            sigs[i] = bytes32(i);
        }
        flp.verify(pkHash, pks, sigs, msgHash);
    }
    function test_verify_1() public {
        bytes32[512] memory pks;
        for (uint256 i = 0; i < 512; i++) {
            pks[i] = keccak256(abi.encodePacked(i));
        }
        bytes32 pkHash = keccak256(abi.encodePacked(pks));
        bytes32 msgHash = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        bytes32[256] memory sigs;
        for (uint256 i = 0; i < 256; i++) {
            sigs[i] = bytes32(256 + i);
        }
        flp.verify(pkHash, pks, sigs, msgHash);
    }
    function test_verify_random() public {
        bytes32[512] memory pks;
        for (uint256 i = 0; i < 512; i++) {
            pks[i] = keccak256(abi.encodePacked(i));
        }
        bytes32 pkHash = keccak256(abi.encodePacked(pks));
        bytes32 msgHash = keccak256(abi.encodePacked("test"));
        bytes32[256] memory sigs;
        for (uint256 i = 0; i < 256; i++) {
            bool ith = ((1 << i) & uint(msgHash)) > 0;
            if (ith) {
                sigs[i] = bytes32(256 + i);
            } else {
                sigs[i] = bytes32(i);
            }
        }
        flp.verify(pkHash, pks, sigs, msgHash);
    }
}
