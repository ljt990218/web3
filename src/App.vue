<script setup lang="ts">
import { Web3 } from 'web3'
var web3 = new Web3(Web3.givenProvider || 'http://127.0.0.1:8545')
// console.log(web3)

// 查询地址余额
web3.eth.getBalance('0x6287a83c187cCcAf979B07519C1da44712aC90c9').then(res => {
    console.log(res.toString())
})

// 转账
// web3.eth
//     .sendTransaction({
//         from: '0x6287a83c187cCcAf979B07519C1da44712aC90c9',
//         to: '0x9A472F6086b77a671d94dBf0e6C25A46546E6e1D',
//         value: '1000000000000000',
//     })
//     .then(res => {
//         console.log(res)
//     })
</script>

<template>
    <router-view />
</template>
