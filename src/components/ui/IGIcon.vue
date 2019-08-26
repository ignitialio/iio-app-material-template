<template>
  <div class="tw-cursor-pointer tw-select-none
    tw-flex
    tw-justify-center tw-items-center tw-overflow-hidden"
    :class="{ 'tw-w-10 tw-h-10' : size === 'small',
      'tw-w-12 tw-h-12' : size === 'medium',
      'tw-w-16 tw-h-16' : size === 'large' }">

    <i v-if="type" class="material-icons"
      :class="{ 'tw-text-2xl' : size === 'small',
        'tw-text-4xl' : size === 'medium',
        'tw-text-6xl' : size === 'large' }">{{ type }}</i>

    <img v-if="src" :src="src"
      :class="{ 'tw-w-6 tw-h-6' : size === 'small',
        'tw-w-8 tw-h-8' : size === 'medium',
        'tw-w-10 tw-h-10' : size === 'large',
        'tw-rounded-full': rounded }"/>
  </div>
</template>

<script>
export default {
  name: 'ig-icon',
  props: {
    type: String,
    size: {
      type: String,
      default: 'medium'
    },
    src: String,
    rounded: Boolean
  },
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

@media screen and (max-width: 800px) {

}
</style>
