<template>
  <div class="item-layout tw-w-full tw-overflow-y-auto">
    <ig-form v-if="schema" class="item-form tw-w-2/3"
      v-model="item" :schema.sync="schema"
      :editable="$store.state.user.role === 'admin' && editMode">
    </ig-form>
  </div>
</template>

<script>
import * as d3 from 'd3'

export default {
  data: () => {
    return {
      editMode: null,
      item: null,
      schema: null,
      itemModified: false
    }
  },
  watch: {
    item: {
      handler: function(val) {
        this.itemModified = true
        this.$services.emit('view:item:modified', true)
      },
      deep: true
    }
  },
  methods: {
    update() {
      if (this.collection) {
        this.$db.collection(this.collection).then(items => {
          items.dFind(this.item).then(result => {
            console.log(result)
          }).catch(err => console.log(err))
        }).catch(err => console.log(err))
      }
    },
    handleEditMode(val) {
      this.editMode = val
    },
    handleSaveItem() {
      this.$db.collection(this.collection).then(async items => {
        try {
          if (this.item._id) {
            await items.dUpdate({ _id: this.item._id }, this.item)
          } else {
            let result = await items.dPut(this.item)
            console.log(result)
          }

          this.itemModified = false
          this.$services.emit('view:item:modified', false)
          this.$services.emit('app:notification', this.$t('Modification done'))
        } catch (err) {
          this.$services.emit('app:notification', this.$t('Modification failed'))
        }
      }).catch(err => console.log(err))
    }
  },
  mounted() {
    this._listeners = {
      onEditMode: this.handleEditMode.bind(this),
      onItemSave: this.handleSaveItem.bind(this)
    }

    this.collection = this.$router.currentRoute.query.collection
    this.item = JSON.parse(this.$router.currentRoute.query.data)
    this.schema = JSON.parse(this.$router.currentRoute.query.schema)

    this.$services.emit('app:context:bar', 'item-ctx')

    this.$services.on('view:item:edit', this._listeners.onEditMode)
    this.$services.on('view:item:save', this._listeners.onItemSave)
  },
  beforeDestroy() {
    this.$services.emit('app:context:bar', null)

    this.$services.off('view:item:edit', this._listeners.onEditMode)
    this.$services.off('view:item:save', this._listeners.onItemSave)
  }
}
</script>

<style>
.item-layout {
  height: calc(100% - 0px);
}

.item-form {
  margin: 16px 15%;
}
</style>
