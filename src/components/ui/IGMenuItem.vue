<template>
  <div v-if="(item.anonymousAccess && !logged) || (logged && !item.hideIfLogged)"
    class="menuitem-layout tw-w-full tw-h-10
      tw-flex tw-items-center tw-px-4
      tw-border-b tw-border-yellow-300
      tw-text-gray-700 hover:tw-text-yellow-700 hover:tw-bg-gray-100
      tw-cursor-pointer tw-select-none"
    :class="{ 'tw-text-yellow-600': item.selected }"
    @click="handleClick">
    <i class="material-icons tw-text-6xl">{{ item.icon }}</i>
    <span class="tw-m-4">{{ $t(item.title) }}</span>
  </div>
</template>

<script>
export default {
  name: 'ig-menuitem',
  props: {
    item: {}
  },
  data: () => {
    return {
    }
  },
  watch: {
  },
  methods: {
    handleClick() {
      this.item.selected = true
      this.$emit('select', this.item)
    }
  },
  mounted() {
  },
  computed: {
    logged() {
      return !!this.$store.state.user
    }
  }
}
</script>

<style scoped>
.menuitem-layout {

}

@media screen and (max-width: 800px) {

}
</style>
