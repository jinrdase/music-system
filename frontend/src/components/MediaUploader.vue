<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { uploadMedia } from '../api/admin'
const props=defineProps({ kind: { type:String, default:'image' }, compact: { type:Boolean, default:false } })
const emit=defineEmits(['uploaded']);const file=ref(null),busy=ref(false),url=ref('')
function onFileChange(event){file.value=event.target.files?.[0]||null}
async function upload(){if(!file.value)return ElMessage.warning('请先选择文件');busy.value=true;try{const result=await uploadMedia(props.kind,file.value);url.value=result.url;emit('uploaded',result.url);ElMessage.success('文件已上传');file.value=null}catch{}finally{busy.value=false}}
</script>
<template><section v-if="!compact" class="content-card"><div class="section-head"><h3>{{kind==='image'?'图片':'音频'}}上传</h3><span class="muted">文件由后端校验并保存</span></div><div class="toolbar"><input type="file" :accept="kind==='image'?'image/png,image/jpeg,image/webp':'audio/mpeg,audio/wav,audio/ogg'" @change="onFileChange"/><el-button type="primary" :loading="busy" :disabled="busy" :data-file-selected="Boolean(file)" @click="upload">上传</el-button></div><el-input v-if="url" :model-value="url" readonly/><img v-if="kind==='image'&&url" class="media-preview" :src="url" alt="上传预览"/></section><div v-else class="toolbar" style="display:inline-flex;align-items:center;gap:8px"><input type="file" :accept="kind==='image'?'image/png,image/jpeg,image/webp':'audio/mpeg,audio/wav,audio/ogg'" @change="onFileChange"/><el-button size="small" type="primary" :loading="busy" :disabled="busy" :data-file-selected="Boolean(file)" @click="upload">上传</el-button><img v-if="kind==='image'&&url" :src="url" alt="已上传" style="width:34px;height:34px;object-fit:cover;border-radius:6px"/></div></template>
