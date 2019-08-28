<template>
  <div class="itemctx-layout">
    <div style="flex: 1"></div>

    <ig-iconswitch v-model="editMode" size="small" type="edit"
      :title="$t('Schema edit')"></ig-iconswitch>

    <v-btn icon :title="$t('Load schema')" @click="handleSchemaLoad">
      <v-icon>open_in_browser</v-icon>
    </v-btn>

    <div style="width: 3em"></div>

    <v-btn icon :title="$t('Save item')" @click="handleItemSave">
      <v-icon>save</v-icon>
    </v-btn>
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
  width: full;
  height: calc(100% - 0px);
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

@media screen and (max-width: 800px) {

}
</style>
