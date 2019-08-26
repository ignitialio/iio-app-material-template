<template>
  <div class="notification-layout tw-w-full tw-fixed tw-bottom-0 tw-h-16
    tw-flex tw-items-center tw-justify-center"
    :class="{ 'visible': !!value }">

    <div class="notification-panel tw-h-16 tw-px-8
      tw-rounded tw-flex tw-items-center tw-justify-center
      tw-bg-yellow-300 tw-border tw-border-yellow-600 tw-text-yellow-700">
      <div>{{ message }}</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ig-notification',
  props: {
    value: {
      type: String,
      default: null
    },
    duration: {
      type: Number,
      default: 5000
    }
  },
  data() {
    return {
      message: null
    }
  },
  watch: {
    value: function(val) {
      if (val) {
        this.message = val
        setTimeout(() => {
          this.$emit('input', null)
        }, this.duration)
      }
    }
  }
}
</script>

<style scoped>
.notification-layout {
  transition: bottom 1s ease;
  bottom: -4em;
}

.notification-layout.visible {
  bottom: 0;
}

.notification-panel {
  max-width: 50%;
  border-bottom: none;
}

@media screen and (max-width: 800px) {

}
</style>
