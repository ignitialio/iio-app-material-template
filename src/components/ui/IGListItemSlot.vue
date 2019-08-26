<template>
  <div :id="id" class="listitemslot-layout tw-w-full tw-h-12
      tw-flex
      tw-border-b tw-border-yellow-300
      tw-cursor-pointer tw-select-none"
    :class="{
      'tw-text-gray-700 hover:tw-text-yellow-700 hover:tw-bg-gray-100': !selected,
      'tw-bg-yellow-600 hover:tw-text-yellow-300 tw-text-white' : selected
    }"
    @click="handleClick">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'ig-listitem-slot',
  props: {
    selected: {
      type: Boolean
    }
  },
  data: () => {
    return {
      id: 'li_' + Math.random().toString(36).slice(2)
    }
  },
  methods: {
    handleClick() {
      this.$emit('select', this.item)
      this.$emit('update:selected', !this.selected)
    }
  }
}
</script>

<style scoped>
.listitemslot-layout {

}

@media screen and (max-width: 800px) {

}
</style>
