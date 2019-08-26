<template>
  <div class="myitemsctx-layout tw-w-full tw-flex tw-justify-end tw-items-center">
    <ig-iconswitch v-model="editMode" size="small" type="edit"
      :title="$t('Schema edit')"></ig-iconswitch>
    <ig-iconbutton size="small" type="open_in_browser"
      :title="$t('Load schema')" @click="handleSchemaLoad"></ig-iconbutton>
    <div style="width: 3em"></div>
    <ig-iconbutton size="small" type="add"
      :title="$t('Add item')" @click="handleItemAdd"></ig-iconbutton>
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
  height: calc(100% - 0px);
}

@media screen and (max-width: 800px) {

}
</style>
