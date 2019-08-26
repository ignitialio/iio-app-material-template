<template>
  <div class="list-layout tw-flex tw-flex-col tw-overflow-y-auto">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'ig-list',
  data: () => {
    return {
    }
  },
  methods: {
  },
  mounted() {
  },
  computed: {
  }
}
</script>

<style scoped>
.list-layout {
  height: calc(100% - 0px);
}

@media screen and (max-width: 800px) {

}
</style>
