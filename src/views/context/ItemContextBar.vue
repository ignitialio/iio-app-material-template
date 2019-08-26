<template>
  <div class="itemctx-layout tw-w-full tw-flex tw-justify-end tw-items-center">
    <div style="flex: 1"></div>

    <ig-iconswitch v-model="editMode" size="small" type="edit"
      :title="$t('Schema edit')"></ig-iconswitch>
    <ig-iconbutton size="small" type="open_in_browser"
      :title="$t('Load schema')" @click="handleSchemaLoad"></ig-iconbutton>

    <div style="width: 3em"></div>

    <ig-iconbutton v-if="modified" size="small" type="save"
      :title="$t('Save item')" @click="handleItemSave"></ig-iconbutton>
  </div>
</template>

<script>
export default {
  name: 'ig-itemctx',
  data: () => {
    return {
      editMode: false,
      modified: false
    }
  },
  watch: {
    editMode: function(val) {
      this.$services.emit('view:item:edit', val)
    }
  },
  methods: {
    handleItemSave() {
      this.$services.emit('view:item:save')
    },
    handleItemModified(status) {
      this.modified = status
    },
    handleSchemaLoad() {
      this.$services.emit('view:schema:load')
    }
  },
  mounted() {
    this._listeners = {
      onItemModified: this.handleItemModified.bind(this)
    }

    this.$services.on('view:item:modified', this._listeners.onItemModified)
  },
  beforeDestroy() {
    this.$services.off('view:item:modified', this._listeners.onItemModified)
  }
}
</script>

<style scoped>
.itemctx-layout {
  height: calc(100% - 0px);
}

@media screen and (max-width: 800px) {

}
</style>
