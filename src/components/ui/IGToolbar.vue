<template>
  <div class="toolbar-layout tw-w-screen tw-flex">
    <ig-iconbutton v-if="!onlyTitleBar"
      src="assets/ignitialio-32.png"
      @click="handleMenuToggle" size="medium"></ig-iconbutton>

    <div class="tw-flex-1 tw-flex tw-justify-center">
      <slot></slot>
    </div>

    <ig-icon v-if="!onlyTitleBar"
      rounded :src="$store.state.user.picture.thumbnail"></ig-icon>
  </div>
</template>

<script>
export default {
  name: 'ig-toolbar',
  props: {
    showMenu: {
      type: Boolean,
      default: false
    },
    onlyTitleBar: Boolean
  },
  data: () => {
    return {

    }
  },
  methods: {
    handleMenuToggle() {
      this.$emit('update:showMenu', !this.showMenu)
    }
  },
  mounted() {
  },
  computed: {
  }
}
</script>

<style scoped>
.toolbar-layout {
  background-color: rgba(255, 255, 255, 0.5);
  height: 48px;
}

.

@media screen and (max-width: 800px) {

}
</style>
