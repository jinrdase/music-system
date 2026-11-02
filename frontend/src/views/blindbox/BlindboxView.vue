<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { blindboxes, blindboxDetail, drawRecords, createBlindboxOrder } from '../../api/blindbox'
import { addresses } from '../../api/user'
import { useUserStore } from '../../stores/user'
import PageTitle from '../../components/PageTitle.vue'

const user = useUserStore()
const router = useRouter()
const rows = ref([])
const loading = ref(false)
const page = ref(1)
const total = ref(0)
const detail = ref(null)
const records = ref([])
const addressList = ref([])
const addressId = ref(null)
const drawCount = ref(1)
const buying = ref(false)

async function load() {
  loading.value = true
  try {
    const result = await blindboxes({ current: page.value, size: 12 })
    rows.value = result?.records || []
    total.value = Number(result?.total || 0)
    if (user.isLoggedIn) {
      const drawResult = await drawRecords({ current: 1, size: 10 })
      records.value = drawResult?.records || []
    }
  } finally {
    loading.value = false
  }
}

async function show(row) {
  detail.value = await blindboxDetail(row.id)
  drawCount.value = 1
  if (user.isLoggedIn) {
    addressList.value = await addresses() || []
    addressId.value = (addressList.value.find(address => Number(address.isDefault) === 1)
      || addressList.value[0])?.id || null
  }
}

async function buy() {
  if (!user.isLoggedIn) return router.push({ path: '/login', query: { redirect: '/blindboxes' } })
  if (!addressId.value) return ElMessage.warning('请先添加收货地址')
  buying.value = true
  try {
    const order = await createBlindboxOrder({
      boxId: detail.value.blindBox.id,
      drawCount: drawCount.value,
      addressId: addressId.value,
    })
    ElMessage.success('盲盒待支付订单已创建')
    detail.value = null
    router.push(`/orders/${encodeURIComponent(order.orderNo)}`)
  } finally {
    buying.value = false
  }
}

onMounted(load)
</script>

<template>
  <PageTitle eyebrow="MYSTERY EDITION" title="音乐盲盒" description="探索当前上架盲盒与公开奖品配置。" />
  <div class="blindbox-banner">下单会创建真实待支付订单；支付完成后由后端执行盲盒抽取。</div>

  <div v-loading="loading" class="album-grid">
    <article v-for="box in rows" :key="box.id" class="content-card blindbox-card">
      <img
        v-if="box.coverUrl"
        class="blindbox-cover"
        :src="box.coverUrl"
        :alt="`${box.name} 商品图`"
        loading="lazy"
      />
      <div v-else class="blindbox-cover-placeholder" aria-label="暂无盲盒图片">◉</div>
      <span class="eyebrow">LIMITED MYSTERY</span>
      <h2>{{ box.name }}</h2>
      <p class="muted">{{ box.description || '收藏一份未知惊喜' }}</p>
      <strong class="price-large">¥ {{ box.price }}</strong>
      <p class="muted">剩余 {{ box.remainCount ?? '—' }}</p>
      <el-button type="primary" @click="show(box)">查看详情</el-button>
    </article>
  </div>
  <el-empty v-if="!loading && !rows.length" description="暂无上架盲盒" />
  <div class="pagination">
    <el-pagination
      v-model:current-page="page"
      :page-size="12"
      :total="total"
      layout="prev,pager,next"
      @current-change="load"
    />
  </div>

  <section v-if="user.isLoggedIn" class="content-card">
    <h2>我的抽取记录</h2>
    <el-table :data="records">
      <el-table-column label="奖品图片" width="100">
        <template #default="{ row }">
          <img v-if="row.imageUrl" class="prize-thumbnail" :src="row.imageUrl" :alt="row.prizeName" loading="lazy" />
          <span v-else class="muted">暂无图片</span>
        </template>
      </el-table-column>
      <el-table-column prop="boxId" label="盲盒 ID" />
      <el-table-column prop="prizeName" label="奖品" />
      <el-table-column prop="prizeLevel" label="等级" />
      <el-table-column prop="drawCount" label="累计抽数" />
      <el-table-column prop="createTime" label="时间" />
    </el-table>
  </section>

  <el-dialog v-if="detail" v-model="detail" title="盲盒详情" width="min(760px,94vw)">
    <div class="blindbox-detail-heading">
      <img
        v-if="detail.blindBox?.coverUrl"
        class="blindbox-detail-cover"
        :src="detail.blindBox.coverUrl"
        :alt="`${detail.blindBox.name} 商品图`"
      />
      <div>
        <h3>{{ detail.blindBox?.name }}</h3>
        <p>{{ detail.blindBox?.description }}</p>
        <p>价格 ¥{{ detail.blindBox?.price }} · 剩余 {{ detail.blindBox?.remainCount }}</p>
      </div>
    </div>
    <div v-if="user.isLoggedIn" class="toolbar">
      <el-select v-model="drawCount">
        <el-option label="单抽" :value="1" />
        <el-option label="十连抽" :value="10" />
      </el-select>
      <el-select v-model="addressId" placeholder="选择收货地址">
        <el-option
          v-for="address in addressList"
          :key="address.id"
          :label="`${address.receiverName} · ${address.fullAddress}`"
          :value="address.id"
        />
      </el-select>
      <el-button type="primary" :loading="buying" @click="buy">创建待支付订单</el-button>
    </div>
    <el-table :data="detail.prizes || []">
      <el-table-column label="奖品图片" width="100">
        <template #default="{ row }">
          <img v-if="row.imageUrl" class="prize-thumbnail" :src="row.imageUrl" :alt="row.prizeName" loading="lazy" />
          <span v-else class="muted">暂无图片</span>
        </template>
      </el-table-column>
      <el-table-column prop="prizeName" label="奖品" />
      <el-table-column prop="prizeLevel" label="等级" />
      <el-table-column prop="probability" label="概率" />
    </el-table>
    <p class="muted">支付成功后由后端自动抽取，结果可在“我的抽取记录”中查看。</p>
  </el-dialog>
</template>

<style scoped>
.blindbox-card { overflow: hidden; }
.blindbox-cover, .blindbox-cover-placeholder {
  display: block;
  width: 100%;
  aspect-ratio: 1 / 1;
  object-fit: cover;
  border-radius: 12px;
  margin-bottom: 18px;
  background: linear-gradient(145deg, #453326, #191817);
}
.blindbox-cover-placeholder { display: grid; place-items: center; color: var(--accent); font-size: 56px; }
.blindbox-detail-heading { display: grid; grid-template-columns: minmax(160px, 240px) 1fr; gap: 22px; align-items: center; margin-bottom: 20px; }
.blindbox-detail-cover { width: 100%; aspect-ratio: 1; object-fit: cover; border-radius: 14px; }
.prize-thumbnail { width: 64px; height: 64px; object-fit: cover; border-radius: 8px; }
@media (max-width: 620px) {
  .blindbox-detail-heading { grid-template-columns: 1fr; }
  .blindbox-detail-cover { max-width: 260px; }
}
</style>
