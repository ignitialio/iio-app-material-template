<template>
  <transition name="fade">
    <div v-if="value"
      class="dialog-layout
        tw-fixed tw-top-0 tw-left-0 tw-bottom-0 tw-right-0
        tw-flex tw-justify-center tw-items-center
        tw-z-10"
      @click.prevent.stop="handleClose">

      <div class="dialog tw-flex tw-flex-col
        tw-pointer-events-auto
        tw-bg-white tw-shadow"
        :style="size" @click.prevent.stop="">

        <div v-if="title"
          class="dialog--header tw-m-1 tw-h-16 tw-bg-yellow-600 tw-flex">
          <div class="tw-m-2 tw-text-gray-200">
            <div class="tw-text-md">{{ title }}</div>
            <div v-if="subtitle" class="tw-text-sm">{{ subtitle }}</div>
          </div>
        </div>

        <div class="dialog--content tw-p-1 tw-w-full">
          <slot></slot>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  name: 'ig-dialog',
  props: {
    value: {
      type: Boolean
    },
    title: {
      type: String
    },
    subtitle: {
      type: String
    },
    width: {},
    height: {}
  },
  data: () => {
    return {
    }
  },
  methods: {
    handleClose() {
      this.$emit('input', false)
    }
  },
  mounted() {

  },
  computed: {
    size() {
      let width
      if (typeof this.width === 'number') {
        width = 'width:' + this.width + 'px;'
      } else {
        width = 'width:' + this.width + ';'
      }

      let height
      if (typeof this.height === 'number') {
        height = 'height:' + this.height + 'px;'
      } else {
        height = 'height:' + this.height + ';'
      }

      return width + height
    }
  }
}
</script>

<style scoped>
.dialog-layout {
  background-color: rgba(255, 255, 255, 0.95);
}

.dialog {
  height: calc(100% - 0px);
}

.dialog--content {
  height: calc(100% - 62px);
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 1s;
}

.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}

@media screen and (max-width: 800px) {

}
</style>
