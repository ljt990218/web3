<script setup lang="ts">
import { ref } from 'vue'
import { chageLanguage } from '@/lang/vanti18n'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { useCounterStore } from '@/stores/counter'
import HelloWord from '@/components/HelloWord.vue'
import { showToast, showSuccessToast, showLoadingToast } from 'vant'

const { t, locale } = useI18n()
const counter = useCounterStore()
const { count } = storeToRefs(counter)
// console.log(count);

const router = useRouter()
const goToAbout = () => {
    router.push('/about')
}

// 切换语言
const changeLang = () => {
    locale.value = locale.value == 'zhCN' ? 'enUS' : 'zhCN'
    // 设置 vant语言
    chageLanguage(locale.value)
    localStorage.setItem('currentLang', locale.value)
}

import { Web3 } from 'web3'
var web3 = new Web3(Web3.givenProvider || 'HTTP://127.0.0.1:7545')
// console.log(web3)

// 授权
const requestAccounts = () => {
    web3.eth
        .requestAccounts()
        .then((res: any) => {
            console.log('授权', res)
        })
        .catch((err: any) => {
            console.log('授权失败', err)
        })
}

let accounts = ref([])
let sendFrom = ref('')
let sendFromBalance = ref(0)
let sendTo = ref('')
let sendNum = ref(0.1)

// 获取帐户
const getAccounts = () => {
    web3.eth.getAccounts().then((res: any) => {
        sendFrom.value = res[0]
        sendTo.value = res[1]
        accounts.value = res
        getBalance()
    })
}
getAccounts()

// 查询地址余额
const getBalance = () => {
    web3.eth.getBalance(sendFrom.value).then((res: any) => {
        sendFromBalance.value = Number(web3.utils.fromWei(res, 'ether'))
    })
}

// 加密地址
const toChecksumAddress = (address: string) => {
    return `${address.substring(0, 4)}****${address.substring(address.length - 4)}`
}

// 转账
const sendTransactionFun = () => {
    if (sendNum.value == 0) {
        showToast('转账数量不能为0~')
        return
    }
    if (sendTo.value == '') {
        showToast('接受地址为空啦~')
        return
    }

    showLoadingToast({
        message: '加载中...',
        forbidClick: true,
    })

    web3.eth
        .sendTransaction({
            from: sendFrom.value,
            to: sendTo.value,
            value: Web3.utils.toWei(sendNum.value, 'ether'),
        })
        .then(res => {
            showSuccessToast('转账成功')
            console.log(res)
        })
}
</script>

<template>
    <van-button class="langChangeBtn" size="small" type="default" @click="changeLang">
        {{ locale == 'zhCN' ? '中文' : 'En' }}
    </van-button>
    <HelloWord class="HelloWord" :msg="$t('helloWeb3')" />

    <div class="balance">余额: {{ sendFromBalance }} (ETH)</div>
    <van-field v-model="sendFrom" label="我的地址" />
    <van-field v-model="sendNum" label="数量(ETH)" />
    <van-field v-model="sendTo" label="转账到" />

    <div class="transaction" @click="sendTransactionFun">转账</div>
</template>

<style lang="scss" scoped>
.langChangeBtn {
    position: fixed;
    top: 2px;
    right: 2px;
    z-index: 9999;
}
.HelloWord {
    margin-top: 20px;
}
.balance {
    margin-top: 20px;
    text-align: center;
    font-size: 16px;
}
.transaction {
    margin: 20px auto;
    width: 80%;
    height: 32px;
    border-radius: 8px;
    line-height: 32px;
    text-align: center;
    letter-spacing: 10px;
    color: #fff;
    font-size: 18px;
    background-color: blueviolet;
}
</style>
