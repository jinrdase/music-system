<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { adminSongs, saveSong, deleteSong, adminAlbums } from '../../api/admin'
import PageTitle from '../../components/PageTitle.vue'
import MediaUploader from '../../components/MediaUploader.vue'
import { confirmAction } from '../../utils/confirm'
const rows=ref([]),loading=ref(false),saving=ref(false),albumId=ref(null),page=ref(1),total=ref(0),dialog=ref(false),editId=ref(null),formRef=ref(),form=reactive({albumId:null,title:'',artist:'',duration:180,audioUrl:'',previewUrl:'',previewDuration:30,trackNumber:1,lyrics:''})
// 专辑下拉：与盲盒管理一致，按名称/艺人搜索选择，替代手输专辑 ID
const albums=ref([]),albumLoading=ref(false)
const albumOptions=computed(()=>albums.value.map(a=>({value:a.id,label:`#${a.id} ${a.title} · ${a.artist}`})))
async function loadAlbumOptions(){albumLoading.value=true;try{const p=await adminAlbums({current:1,size:200});albums.value=p?.records||[]}finally{albumLoading.value=false}}
onMounted(loadAlbumOptions)
function selectAlbum(id){albumId.value=id;page.value=1;load()}
const rules={title:[{required:true,message:'请输入歌曲名称'}],artist:[{required:true,message:'请输入艺人'}],duration:[{required:true,message:'请输入歌曲时长'}],trackNumber:[{required:true,message:'请输入曲序'}]}
async function load(){if(!albumId.value)return;loading.value=true;try{const p=await adminSongs({albumId:Number(albumId.value),current:page.value,size:20});rows.value=p?.records||[];total.value=Number(p?.total||0)}finally{loading.value=false}}
function open(row){editId.value=row?.id||null;Object.assign(form,row?{...row}:{albumId:Number(albumId.value),title:'',artist:'',duration:180,audioUrl:'',previewUrl:'',previewDuration:30,trackNumber:1,lyrics:''});dialog.value=true}
async function save(){if(saving.value)return;saving.value=true;try{await formRef.value.validate();await saveSong(editId.value,{...form,albumId:Number(albumId.value||form.albumId),duration:Number(form.duration),previewDuration:Number(form.previewDuration),trackNumber:Number(form.trackNumber)});ElMessage.success('歌曲已保存');dialog.value=false;await load()}catch(error){if(!error?.fields){/* API interceptor already displays request errors. */}}finally{saving.value=false}}
async function remove(row){
  if(!(await confirmAction(`确定删除歌曲「${row.title}」？删除后用户端不再展示该曲目。`,{title:'删除歌曲',confirmText:'删除',cancelText:'保留'})))return
  await deleteSong(row.id)
  ElMessage.success('歌曲已删除')
  if(!rows.value.length&&page.value>1)page.value-=1
  await load()
}
</script>
<template><div class="admin-page"><PageTitle eyebrow="TRACKS" title="歌曲管理" description="先按名称或艺人选择专辑，再查看或编辑该专辑曲目。音频上传使用后端校验过的媒体接口。"/><div class="toolbar"><el-select v-model="albumId" filterable :loading="albumLoading" placeholder="输入专辑名或艺人搜索并选择" style="max-width:320px" @change="selectAlbum"><el-option v-for="opt in albumOptions" :key="opt.value" :label="opt.label" :value="opt.value"/></el-select><el-button :disabled="!albumId" @click="load">刷新</el-button><el-button type="primary" :disabled="!albumId" @click="open()">新增歌曲</el-button></div><el-table v-loading="loading" :data="rows"><el-table-column prop="id" label="ID" width="80"/><el-table-column prop="trackNumber" label="曲序" width="80"/><el-table-column prop="title" label="歌曲"/><el-table-column prop="artist" label="艺人"/><el-table-column prop="duration" label="时长（秒）" width="120"/><el-table-column label="操作" width="150"><template #default="{row}"><el-button text @click="open(row)">编辑</el-button><el-button text type="danger" @click="remove(row)">删除</el-button></template></el-table-column></el-table><div class="pagination"><el-pagination v-model:current-page="page" :page-size="20" :total="total" layout="prev,pager,next" @current-change="load"/></div><el-dialog v-model="dialog" :title="editId?'编辑歌曲':'新建歌曲'"><el-form ref="formRef" :model="form" :rules="rules" label-position="top"><div class="form-grid"><el-form-item label="标题" prop="title"><el-input v-model="form.title"/></el-form-item><el-form-item label="艺人" prop="artist"><el-input v-model="form.artist"/></el-form-item><el-form-item label="曲序" prop="trackNumber"><el-input v-model="form.trackNumber" type="number"/></el-form-item><el-form-item label="时长秒" prop="duration"><el-input v-model="form.duration" type="number"/></el-form-item><el-form-item label="正式音频 URL" class="span-2"><el-input v-model="form.audioUrl"/><MediaUploader kind="audio" @uploaded="form.audioUrl = $event"/></el-form-item><el-form-item label="试听音频 URL" class="span-2"><el-input v-model="form.previewUrl"/><MediaUploader kind="audio" @uploaded="form.previewUrl = $event"/></el-form-item><el-form-item label="试听时长秒"><el-input v-model="form.previewDuration" type="number"/></el-form-item><el-form-item label="歌词" class="span-2"><el-input v-model="form.lyrics" type="textarea" maxlength="10000"/></el-form-item></div></el-form><template #footer><el-button @click="dialog=false">取消</el-button><el-button type="primary" :loading="saving" :disabled="saving" @click="save">保存</el-button></template></el-dialog></div></template>
