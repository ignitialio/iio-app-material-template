<template>
  <div class="listctx-layout">
    <v-icon color="grey">search</v-icon>
    <input
      class="listctx-search"
      :placeholder="$t('Search')" @change="handleSearch"/>

    <div style="flex: 1"></div>

    <div class="listctx-divider"></div>

    <ig-iconswitch v-model="editMode" size="small" type="edit"
      :title="$t('Document edit')"></ig-iconswitch>

    <div class="listctx-divider"></div>

    <v-btn icon :title="$t('Add item')" @click="handleItemAdd">
      <v-icon color="green darken-2">add</v-icon>
    </v-btn>

    <ig-fileinput button loadToBrowser :title="$t('Load item')" @load="handleItemLoad"/>

    <div class="listctx-divider"></div>
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
    handleSearch(event) {
      this.$services.emit('view:list:search', event.target.value)
    }
  }
}
</script>

<style scoped>
.listctx-layout {
  width: 100%;
  height: calc(100% - 0px);
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.listctx-search {
  outline: none;
  color: dimgray;
  border-bottom: 1px solid gainsboro;
}

.listctx-search:focus {
  border-bottom: 1px solid dodgerblue;
}

.listctx-divider {
  height: 32px;
  border-left: 1px solid gainsboro;
}

@media screen and (max-width: 800px) {

}
</style>
