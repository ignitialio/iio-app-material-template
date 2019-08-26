<template>
  <div class="listctx-layout tw-w-full tw-flex tw-justify-end tw-items-center">
    <ig-input  class="tw-mx-4" @change="handleSearch" icon="search"
      :label="$t('Search')"/>

    <div style="flex: 1"></div>

    <div style="width: 3em"></div>

    <ig-iconbutton size="small" type="add"
      :title="$t('Add item')" @click="handleItemAdd"></ig-iconbutton>

    <ig-fileinput button loadToBrowser :title="$t('Load item')" @load="handleItemLoad"/>
  </div>
</template>

<script>
export default {
  name: 'ig-listctx',
  data: () => {
    return {
      editMode: false
    }
  },
  watch: {
    editMode: function(val) {
      this.$services.emit('view:list:edit', val)
    }
  },
  methods: {
    handleItemAdd() {
      this.$services.emit('view:list:add')
    },
    handleItemLoad(data) {
      this.$services.emit('view:list:loaded', data)
    },
    handleSearch(data) {
      this.$services.emit('view:list:search', data)
    }
  }
}
</script>

<style scoped>
.listctx-layout {
  height: calc(100% - 0px);
}

@media screen and (max-width: 800px) {

}
</style>
