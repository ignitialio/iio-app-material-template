<template>
  <div class="tw-cursor-pointer tw-select-none
    tw-flex tw-m-2
    tw-justify-center tw-items-center tw-border tw-border-gray-400 tw-rounded-sm"
    :class="{ 'tw-w-8 tw-h-8' : size === 'small',
      'tw-w-10 tw-h-10' : size === 'medium',
      'tw-w-12 tw-h-12' : size === 'large',
      'hover:tw-text-yellow-500 active:tw-text-yellow-600': type && !value,
      'tw-bg-yellow-500 tw-text-gray-200 hover:tw-text-yellow-400 hover:tw-bg-yellow-700 tw-overflow-hidden': value,
      'iconbut': src }"
    @click="handleClick">

    <div class="tw-absolute tw-flex tw-justify-center tw-items-center"
      :class="{ 'tw-w-10 tw-h-10' : size === 'small',
        'tw-w-12 tw-h-12' : size === 'medium',
        'tw-w-16 tw-h-16' : size === 'large' }">
      <i v-if="type"
        class="material-icons tw-absolute tw-flex tw-justify-center tw-items-center"
        :class="{ 'tw-text-2xl tw-w-8 tw-h-8 tw-p-1' : size === 'small',
          'tw-text-4xl tw-w-8 tw-h-8 tw-p-1' : size === 'medium',
          'tw-text-6xl tw-w-10 tw-h-10 tw-p-1' : size === 'large' }">{{ type }}</i>
    </div>

    <img v-if="src" :src="src"
      :class="{ 'tw-w-6 tw-h-6' : size === 'small',
        'tw-w-8 tw-h-8' : size === 'medium',
        'tw-w-10 tw-h-10' : size === 'large' }"/>
  </div>
</template>

<script>
export default {
  name: 'ig-iconswitch',
  props: {
    type: String,
    value: {
      type: Boolean
    },
    size: {
      type: String,
      default: 'medium'
    },
    src: String
  },
  data: () => {
    return {
    }
  },
  methods: {
    handleClick(e) {
      this.$emit('input', !this.value)
    }
  },
  mounted() {
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
