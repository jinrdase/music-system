<script setup>
defineProps({ eyebrow: String, title: String, description: String })
</script>
<template><div class="page-title"><span v-if="eyebrow" class="eyebrow">{{eyebrow}}</span><h1>{{title}}</h1><p v-if="description">{{description}}</p></div></template>
