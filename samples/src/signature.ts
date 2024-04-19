import {ethers, Mnemonic, keccak256, toUtf8Bytes} from 'ethers'

import dotenv from 'dotenv'
dotenv.config()

const {MNEMONIC} = process.env

async function main() {
    const mnemonic = Mnemonic.fromPhrase(MNEMONIC)
    const provider = new ethers.JsonRpcProvider('http://localhost:8545')
    const wallet = ethers.HDNodeWallet.fromPhrase(MNEMONIC, '')
    const pubWallet = ethers.HDNodeWallet.fromSeed(wallet.mnemonic.computeSeed())
    const pubkeys = []
    for(let i=0;i<512;i++) {
        const childWallet = pubWallet.deriveChild(i)
        pubkeys.push(keccak256(childWallet.privateKey))
    }
    // generate signature
    // generate public key hash
    let signature = []
    const msg = 'hello world'
    const msgHash = keccak256(toUtf8Bytes(msg))
    for (let i=0;i<256;i++) {
        const buff = Buffer.from(msgHash.substring(2), "hex")
        if(buff[buff.length - 1] == 0) {
            signature.push(pubkeys[i])
        } else {
            signature.push(pubkeys[i + 256])
        }
    }
    console.log(signature)
}

main().catch(console.error)

