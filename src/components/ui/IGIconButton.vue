<template>
  <div class="iconbutton-layout tw-cursor-pointer tw-select-none
    tw-flex tw-relative
    tw-justify-center tw-items-center"
    :class="{ 'tw-w-10 tw-h-10' : size === 'small' && !fab,
      'tw-w-12 tw-h-12' : size === 'medium' && !fab,
      'tw-w-16 tw-h-16' : size === 'large' && !fab,
      'tw-m-2 tw-w-8 tw-h-8' : size === 'small' && fab,
      'tw-m-2 tw-w-10 tw-h-10' : size === 'medium' && fab,
      'tw-m-2 tw-w-12 tw-h-12' : size === 'large' && fab,
      'hover:tw-text-yellow-500 active:tw-text-yellow-600': type && !fab && !disabled,
      'tw-bg-yellow-500 tw-text-gray-200 hover:tw-text-yellow-400 hover:tw-bg-yellow-700 tw-rounded-full tw-overflow-hidden': fab,
      'iconbut': src,
      'tw-text-gray-200': disabled }"
    @click="handleClick">

    <div class="tw-absolute tw-flex tw-justify-center tw-items-center"
      :class="{ 'tw-w-10 tw-h-10' : size === 'small',
        'tw-w-12 tw-h-12' : size === 'medium',
        'tw-w-16 tw-h-16' : size === 'large' }">
      <i v-if="type"
        class="material-icons tw-absolute tw-flex tw-justify-center tw-items-center"
        :class="{ 'tw-text-base tw-w-6' : size === 'small',
          'tw-text-4xl tw-w-8' : size === 'medium',
          'tw-text-6xl tw-w-10' : size === 'large' }">{{ type }}</i>
    </div>

    <img v-if="src" :src="src"
      :class="{ 'tw-w-6 tw-h-6' : size === 'small',
        'tw-w-8 tw-h-8' : size === 'medium',
        'tw-w-10 tw-h-10' : size === 'large' }"/>
  </div>
</template>

<script>
import * as d3 from 'd3'

export default {
  name: 'ig-iconbutton',
  props: {
    type: String,
    fab: {
      type: Boolean
    },
    color: {
      type: String,
      default: 'gray'
    },
    size: {
      type: String,
      default: 'medium'
    },
    disabled: {
      type: Boolean
    },
    src: String
  },
  data: () => {
    return {
    }
  },
  methods: {
    handleClick(e) {
      if (!this.disabled) {
        this.$emit('click', e)
      }
    }
  },
  mounted() {
    d3.select(this.$el).classed('tw-text-' +
      this.color + '-600', true)
  },
  computed: {
  }
}
</script>

<style scoped>
.iconbut {
  -webkit-filter: drop-shadow(0px 0px 0px rgba(0, 0, 0, 0));
  filter: drop-shadow(0px 0px 0px rgba(0, 0, 0, 0));
}

.iconbut:hover {
  -webkit-filter: drop-shadow(0px 0px 2px dimgray);
  filter: drop-shadow(0px 0px 2px dimgray);
}

.iconbut:active {
  -webkit-filter: drop-shadow(0px 0px 1px black);
  filter: drop-shadow(0px 0px 1px black);
}

@media screen and (max-width: 800px) {

}
</style>
