<script setup>
import { computed, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { uploadMedia } from '../api/admin'
const props=defineProps({ kind: { type:String, default:'image' }, compact: { type:Boolean, default:false } })
const emit=defineEmits(['uploaded']);const file=ref(null),busy=ref(false),url=ref('')
const accept=computed(()=>props.kind==='image'?'image/png,image/jpeg,image/webp':'audio/mpeg,audio/wav,audio/ogg')
function onFileChange(event){file.value=event.target.files?.[0]||null}
async function upload(){if(!file.value)return ElMessage.warning('请先选择文件');busy.value=true;try{const result=await uploadMedia(props.kind,file.value);url.value=result.url;emit('uploaded',result.url);ElMessage.success('文件已上传');file.value=null}catch{}finally{busy.value=false}}
</script>
<template>
  <section v-if="!compact" class="media-uploader">
    <div class="media-upload-row">
      <label class="media-file-btn">
        <input type="file" :accept="accept" @change="onFileChange"/>
        选择文件
      </label>
      <span class="media-file-name" :title="file?.name">{{file?.name||'未选择文件'}}</span>
      <el-button type="primary" :loading="busy" :disabled="busy" :data-file-selected="Boolean(file)" @click="upload">上传</el-button>
    </div>
    <div v-if="url" class="media-upload-result">
      <img v-if="kind==='image'" class="media-preview" :src="url" alt="上传预览"/>
      <el-input :model-value="url" readonly/>
    </div>
  </section>
  <div v-else class="media-uploader-compact">
    <label class="media-file-btn media-file-btn--small">
      <input type="file" :accept="accept" @change="onFileChange"/>
      选择文件
    </label>
    <el-button size="small" type="primary" :loading="busy" :disabled="busy" :data-file-selected="Boolean(file)" @click="upload">上传</el-button>
    <span v-if="file" class="media-file-name">{{file.name}}</span>
    <img v-if="kind==='image'&&url" :src="url" alt="已上传" class="media-upload-thumb"/>
  </div>
</template>
<style scoped>
.media-uploader{display:grid;gap:12px}
.media-upload-row{display:flex;align-items:center;gap:12px;flex-wrap:wrap}
.media-file-btn{
  position:relative;display:inline-flex;align-items:center;padding:8px 16px;
  border-radius:10px;border:1px solid rgba(255,255,255,.24);
  background:rgba(255,255,255,.09);color:var(--text);
  font-weight:600;font-size:14px;cursor:pointer;user-select:none;
  transition:background .15s,border-color .15s;
}
.media-file-btn:hover{background:rgba(255,255,255,.15);border-color:rgba(255,255,255,.42)}
.media-file-btn input{position:absolute;inset:0;opacity:0;cursor:pointer;font-size:0}
.media-file-name{font-size:13px;color:var(--muted);min-width:0;max-width:280px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.media-upload-result{display:flex;align-items:center;gap:12px;flex-wrap:wrap}
.media-upload-result .el-input{max-width:420px}
.media-file-btn--small{padding:5px 12px;font-size:12px;border-radius:8px}
.media-uploader-compact{display:inline-flex;align-items:center;gap:8px;flex-wrap:wrap}
.media-upload-thumb{width:34px;height:34px;object-fit:cover;border-radius:6px}
</style>
