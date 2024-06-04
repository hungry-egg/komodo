<script setup lang="ts">
  import {ref} from "vue";
  import {coordFromClick} from "../helpers/coordFromClick"

  const props = defineProps<{
    marker: [number, number]
  }>();

  const emit = defineEmits(['selectCoord'])

  const handleClick = (event) => {
    const [ x, y] = coordFromClick(event);
    emit("selectCoord", x, y)
  }

</script>

<template>
  <div class="container" @click="handleClick">
    <div class="marker" :style="{left: `${marker[0]}%`, top: `calc(100% - ${marker[1]}%)`}" />
  </div>
</template>

<style scoped>
  .container {
    width: 200px;
    height: 200px;
    position: relative;
    border: 1px solid slategrey;
    border-radius: 4px;
  }

  .marker {
    width: 32px;
    height: 32px;
    margin-top: -16px;
    margin-left: -16px;
    background: url("https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Vue.js_Logo_2.svg/1024px-Vue.js_Logo_2.svg.png") no-repeat 50% 50%;
    background-size: contain;
    position: absolute;
  }
</style>
