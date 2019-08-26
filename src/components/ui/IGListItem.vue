<template>
  <div :id="id" class="listitem-layout tw-w-full tw-h-12
      tw-flex
      tw-border-b tw-border-yellow-300
      tw-cursor-pointer tw-select-none"
    :class="{
      'tw-text-gray-700 hover:tw-text-yellow-700 hover:tw-bg-gray-100': !selected,
      'tw-bg-yellow-600 hover:tw-text-yellow-300 tw-text-white' : selected
    }"
    @click="handleClick">

    <div v-if="picture"
      class="tw-flex tw-justify-center tw-items-center tw-w-12 tw-h-12">
      <img v-if="picture"
        class="tw-w-8 tw-h-8" :class="{ 'tw-rounded-full': avatar }"
        :src="picture"/>
    </div>

    <div class="listitem-text tw-mx-4 tw-w-full tw-flex tw-flex-col tw-justify-center tw-overflow-hidden">
      <div class="tw-font-bold tw-w-full">{{ $t(title) }}</div>
      <div v-if="subtitle"
        class="ig-ellipsis tw-w-full tw-text-xs tw-h-4 tw-overflow-hidden">
        {{ $t(subtitle) }}</div>
    </div>

    <ig-iconbutton type="clear" color="red" @click.stop.prevent="handleDelete"/>
  </div>
</template>

<script>
export default {
  name: 'ig-listitem',
  props: {
    selected: {
      type: Boolean
    },
    picture: {},
    title: String,
    subtitle: String,
    item: {},
    avatar: Boolean
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
    },
    handleDelete() {
      this.$emit('delete', this.item)
    }
  }
}
</script>

<style scoped>
.listitem-text {
  flex: 1;
}

@media screen and (max-width: 800px) {

}
</style>
