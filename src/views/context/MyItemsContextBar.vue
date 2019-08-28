<template>
  <div class="myitemsctx-layout">
    <ig-iconswitch v-model="editMode" size="small" type="edit"
      :title="$t('Schema edit')"></ig-iconswitch>
    <v-btn icon :title="$t('Load schema')" @click="handleSchemaLoad">
      <v-icon color="blue darken-2">open_in_browser</v-icon>
    </v-btn>
    <div style="width: 3em"></div>
    <v-btn icon :title="$t('Add item')" @click="handleItemAdd">
      <v-icon color="green darken-2">add</v-icon>
    </v-btn>
  </div>
</template>

<script>
export default {
  name: 'ig-myitemsctx',
  data: () => {
    return {
      editMode: false
    }
  },
  watch: {
    editMode: function(val) {
      this.$services.emit('view:myitems:edit', val)
    }
  },
  methods: {
    handleItemAdd() {
      this.$services.emit('view:myitems:add')
    },
    handleSchemaLoad() {
      this.$services.emit('view:schema:load')
    }
  },
  mounted() {
  },
  computed: {
  }
}
</script>

<style scoped>
.myitemsctx-layout {
  width: 100%;
  height: calc(100% - 0px);
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

@media screen and (max-width: 800px) {

}
</style>
