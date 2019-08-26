<template>
  <div class="tags-layout tw-flex">
    <div v-for="(tag, index) in value">{{ tag }}</div>
  </div>
</template>

<script>
import _ from 'lodash'

export default {
  name: 'ig-tags',
  props: {
    value: {
      type: Array
    }
  },
  data: () => {
    return {
    }
  },
  methods: {
    handleChange(event) {
      this.$emit('input', event.target.value)
    }
  },
  mounted() {
    this._tags = _.cloneDeep(this.value)
  },
  computed: {
  }
}
</script>

<style scoped>
.tags-layout {
}

@media screen and (max-width: 800px) {

}
</style>
