<template>
  <div class="itemctx-layout">
    <div style="flex: 1"></div>

    <div class="itemctx-divider"></div>

    <v-btn icon :title="$t('Load schema')" @click="handleSchemaLoad">
      <v-icon color="green lighten-1">vertical_align_top</v-icon>
    </v-btn>

    <div class="itemctx-divider"></div>

    <v-btn icon light :title="$t('Save item')" @click="handleItemSave"
      :disabled="!modified">
      <v-icon color="blue lighten-1">save</v-icon>
    </v-btn>

    <div class="itemctx-divider"></div>
  </div>
</template>

<script>
export default {
  name: 'ig-itemctx',
  data: () => {
    return {
      modified: false
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

.itemctx-divider {
  height: 32px;
  border-left: 1px solid gainsboro;
}

@media screen and (max-width: 800px) {

}
</style>
