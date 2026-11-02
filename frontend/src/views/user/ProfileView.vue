<script setup>
import { onMounted, ref } from 'vue'
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { updateProfile, changePassword, uploadAvatar } from '../../api/auth'
import { useUserStore } from '../../stores/user'
import PageTitle from '../../components/PageTitle.vue'
const store=useUserStore(),profile=ref(store.user),loading=ref(false)
const edit=ref(false),passwordOpen=ref(false),pw=reactive({oldPassword:'',newPassword:'',confirmPassword:''})
async function load(){loading.value=true;try{profile.value=await store.refreshUser()}finally{loading.value=false}}
async function save(){profile.value=await updateProfile({nickname:profile.value.nickname,phone:profile.value.phone,email:profile.value.email,avatar:profile.value.avatar});await store.refreshUser();edit.value=false;ElMessage.success('资料已更新')}
async function avatar(file){if(file){const r=await uploadAvatar(file);profile.value.avatar=r.url;ElMessage.success('头像上传成功，请保存资料')}}
async function savePassword(){if(pw.newPassword!==pw.confirmPassword)return ElMessage.warning('两次新密码不一致');await changePassword(pw);store.logout();ElMessage.success('密码已修改，请重新登录');location.href='/login'}
onMounted(load)
</script>
<template><PageTitle eyebrow="YOUR ACCOUNT" title="个人中心"/><div v-loading="loading" class="content-card" v-if="profile"><el-form label-position="top"><el-form-item label="用户名"><el-input :model-value="profile.username" disabled/></el-form-item><el-form-item label="昵称"><el-input v-model="profile.nickname" :disabled="!edit"/></el-form-item><el-form-item label="手机"><el-input v-model="profile.phone" :disabled="!edit"/></el-form-item><el-form-item label="邮箱"><el-input v-model="profile.email" :disabled="!edit"/></el-form-item><el-form-item label="头像 URL"><el-input v-model="profile.avatar" :disabled="!edit"/></el-form-item><input v-if="edit" type="file" accept="image/png,image/jpeg" @change="avatar($event.target.files[0])"/><div class="actions"><el-button v-if="!edit" @click="edit=true">编辑资料</el-button><template v-else><el-button @click="load();edit=false">取消</el-button><el-button type="primary" @click="save">保存</el-button></template><el-button @click="passwordOpen=true">修改密码</el-button><RouterLink to="/addresses"><el-button>收货地址</el-button></RouterLink><RouterLink to="/orders"><el-button>我的订单</el-button></RouterLink><RouterLink to="/refunds"><el-button>退款记录</el-button></RouterLink></div></el-form><el-dialog v-model="passwordOpen" title="修改密码"><el-form label-position="top"><el-form-item label="当前密码"><el-input v-model="pw.oldPassword" type="password" show-password/></el-form-item><el-form-item label="新密码"><el-input v-model="pw.newPassword" type="password" show-password/></el-form-item><el-form-item label="确认新密码"><el-input v-model="pw.confirmPassword" type="password" show-password/></el-form-item></el-form><template #footer><el-button @click="passwordOpen=false">取消</el-button><el-button type="primary" @click="savePassword">确认修改</el-button></template></el-dialog></div></template>
