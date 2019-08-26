<template>
  <div class="box-layout tw-flex"
    :class="{ 'vfill': verticalFill }">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'ig-box',
  props: {
    verticalFill: {
      type: Boolean
    }
  }
}
</script>

<style scoped>
.box-layout.vfill {
  height: calc(100% - 0px);
}

@media screen and (max-width: 800px) {

}
</style>
