<template>
  <div class="paper-layout
    md:tw-relative tw-w-screen tw-p-4
    md:tw-shadow-md md:hover:tw-shadow">
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'ig-paper',
  data: () => {
    return {
    }
  },
  watch: {
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
.paper-layout {

}

@media screen and (max-width: 800px) {

}
</style>
