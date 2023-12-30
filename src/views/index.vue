<script setup lang="ts">
import { ref, reactive } from 'vue'
import { chageLanguage } from '@/lang/vanti18n'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { useCounterStore } from '@/stores/counter'
import HelloWord from '@/components/HelloWord.vue'
import { showToast, showSuccessToast, showLoadingToast } from 'vant'
import StudentListStorageABI from '../../solidity/build/contracts/StudentListStorage.json'
import StudentStorageABI from '../../solidity/build/contracts/StudentStorage.json'
import ArrayList from '../../solidity/build/contracts/ArrayList.json'

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
let web3 = new Web3(Web3.givenProvider || 'HTTP://127.0.0.1:7545')

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
// requestAccounts()

let accounts = ref([] as any)
let studentList = ref([] as any)
let name = ref('名字')
let age = ref(18)
const listLoading = ref(false)
const listFinished = ref(true)
// 连接智能合约程序
const studentStorage = new web3.eth.Contract(
    ArrayList.abi,
    '0x015AC3dAfCfEC872C1d06b9FF99Fc5e1a2FDac50'
)
console.log(studentStorage)

// 调用智能合约的获取数组函数
studentStorage.methods.getArray().call((error, result) => {
    console.log(error)
    console.log(result)

    // if (!error) {
    //     console.log(
    //         'Returned Array:',
    //         result.map(value => web3.utils.hexToNumber(value))
    //     )
    // } else {
    //     console.error('Error fetching array:', error)
    // }
})

// 获取帐户
const getAccounts = async () => {
    await web3.eth.getAccounts().then((res: any) => {
        accounts.value = res
        web3.eth.defaultAccount = res[0]
    })

    console.log(studentStorage.methods.myArray.call({ from: accounts.value[0] }))
}
getAccounts()

// 获取列表
const getStudentList = () => {
    studentStorage.methods
        .getStudentList()
        .call({ from: accounts.value[0] })
        .then(res => {
            console.log(res)
        })
    // studentList.value = res
    // console.log('获取列表', res)
}
// getStudentList()

const onLoad = async () => {
    // 获取列表
    // getStudentList()
}

// 添加数据
const addStudentList = async () => {
    if (!name.value || !age.value) {
        showToast({
            message: '请填写完整',
            type: 'fail',
        })
        return
    }
    showLoadingToast({
        message: '添加中...',
    })
    await studentStorage.methods
        .addStudentList(name.value, age.value)
        .send({ from: accounts.value[0] })
        .then((res: any) => {
            // console.log('添加成功', res)
            showSuccessToast({
                message: '添加成功',
            })

            getStudentList()
        })
}
</script>

<template>
    <van-button class="langChangeBtn" size="small" type="default" @click="changeLang">
        {{ locale == 'zhCN' ? '中文' : 'En' }}
    </van-button>
    <HelloWord class="HelloWord" :msg="$t('helloWeb3')" />

    <van-field v-model="name" label="我的名字" />
    <van-field v-model="age" label="年龄" />

    <div class="add" @click="addStudentList">添加</div>

    <!-- <van-list v-model:loading="listLoading" :finished="listFinished" finished-text="没有更多了" @load="onLoad">
        <van-cell v-for="item in studentList" :key="item" :title="item" />
    </van-list> -->
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
.add {
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
