// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;
library Lamport {
    function checkPK(bytes32 pkHash, bytes32[512] memory pks) public pure {
        require(
            keccak256(abi.encodePacked(pks)) == pkHash,
            "Invalid public key"
        );
    }

    function verify(
        bytes32[512] memory pks,
        bytes32[256] memory sigs,
        bytes32 msgHash
    ) public pure {
        for (uint256 i = 0; i < 256; i++) {
            bool ith = ((1 << i) & uint(msgHash)) > 0;
            (ith);
            if (ith) {
                require(
                    keccak256(abi.encodePacked(sigs[i])) == pks[256 + i],
                    "Invalid signature"
                );
            } else {
                require(
                    keccak256(abi.encodePacked(sigs[i])) == pks[i],
                    "Invalid signature"
                );
            }
        }
    }
    function verify(
        bytes32 pkHash,
        bytes32[512] memory pks,
        bytes32[256] memory sigs,
        bytes32 msgHash
    ) public pure {
        checkPK(pkHash, pks);
        verify(pks, sigs, msgHash);
    }

    function msgAndNewPKs(
        bytes32 msgHash,
        bytes32[512] memory pks
    ) public pure returns (bytes32) {
        bytes32 newPKHash = keccak256(abi.encodePacked(pks));
        return keccak256(abi.encodePacked(msgHash, newPKHash));
    }

    function msgAndNewPKHash(
        bytes32 msgHash,
        bytes32 pkHash
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(msgHash, pkHash));
    }
}
