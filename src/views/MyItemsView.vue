<template>
  <div :id="id" class="myitems-layout tw-w-full tw-flex">
    <div class="left-panel tw-w-full lg:tw-w-1/3 tw-relative">
      <ig-progressbar v-if="loading"
        indeterminate class="tw-absolute"></ig-progressbar>
      <ig-list class="list">
        <ig-listitem v-for="(item, index) in myitems" :key="index"
          :item="item" @select="handleSelect" :selected="selected === item"
          :title="item.name.first + ' ' + item.name.last"
          :subtitle="item.location.postcode + ' ' + item.location.city"
          avatar></ig-listitem>
      </ig-list>
    </div>

    <div class="right-panel tw-hidden
      lg:tw-w-2/3 lg:tw-flex tw-flex-row">
      <div class="user-settings tw-p-4 tw-overflow-y-auto">
        <ig-form v-if="!!selected && !!schema"
          v-model="selected" name="user" :schema.sync="schema"
          :editable="$store.state.user.role === 'admin' && editMode">
        </ig-form>
      </div>

      <ig-vbox class="actions-bar tw-w-10 tw-justify-end tw-shadow" verticalFill
        :class="{ 'open': itemModified || editMode && schemaModified}">
        <ig-iconbutton v-if="editMode && schemaModified"
          type="save_alt" size="small"
          @click="handleSaveSchema"></ig-iconbutton>

        <ig-iconbutton v-if="itemModified"
          type="save_alt" size="small"
          @click="handleSaveItem"></ig-iconbutton>
      </ig-vbox>
    </div>
  </div>
</template>

<script>
import * as d3 from 'd3'
import _ from 'lodash'

export default {
  data() {
    return {
      id: 'li_' + Math.random().toString(36).slice(2),
      ready: false,
      myitems: [],
      selected: null,
      loading: false,
      schema: null,
      schemaModified: false,
      itemModified: false,
      editMode: false
    }
  },
  watch: {
    selected: {
      handler: function(val) {
        if (!this.schema) {
          this.schema = this.$utils.generateJSONSchema('myitem', val)
          this.schemaModified = true
        }

        if ($j(val) !== this.lastItemChksum) {
          this.lastItemChksum = $j(val)
          this.itemModified = true
        }
      },
      deep: true
    },
    schema: {
      handler: function(val) {
        if (this.lastSchemaChksum !== $j(val)) {
          this.lastSchemaChksum = $j(val)
          this.schemaModified = true
        }
      },
      deep: true
    }
  },
  methods: {
    handleScroll(event) {
      let element = event.target

      if (element.scrollHeight - element.scrollTop === element.clientHeight) {
        this.showNextElements()
      }
    },
    showNextElements() {
      this.loading = true
      this.myitems = _.concat(this.myitems,
        _.slice(this.myitemsData, this.nextIndex, this.nextIndex + 100))
      this.nextIndex += 100
      setTimeout(() => this.loading = false, 500)
    },
    async handleSelect(item) {
      this.lastItemChksum = $j(item)
      this.itemModified = false
      this.selected = item
    },
    handleSaveSchema() {
      this.$db.collection('schemas').then(async schemas => {
        try  {
          let schema = _.cloneDeep(this.schema)
          schema._schema = this.schema.$schema
          delete schema.$schema

          let myitemsSchema = await schemas.dGet({ name: 'myitems' })

          if (myitemsSchema) {
            let response = await schemas.dUpdate({ name: 'myitems' }, {
              name: 'myitems',
              schema: schema
            })

            console.log('myitems schema updated', response)
          } else {
            let response = schemas.dPut({
              name: 'myitems',
              schema: schema
            })

            console.log('myitems schema created', response)
          }

          this.schemaModified = false
        } catch (err) {
          console.log(err)
        }
      }).catch(err => console.log(err))
    },
    loadSchema() {
      this.$db.collection('schemas').then(async schemas => {
        try {
          let myitemsSchema = await schemas.dGet({ name: 'myitems' })

          if (myitemsSchema) {
            // manage naming restrictions for Mongo
            myitemsSchema.schema.$schema = myitemsSchema.schema._schema
            delete myitemsSchema.schema._schema
            this.schema = myitemsSchema.schema
            this.lastSchemaChksum = $j(this.schema)
            setTimeout(() => this.schemaModified = false, 50)
          } else {
            this.$services.emit('app:notification', this.$t('No related schema'))
            console.log('no myitems schema saved')
          }
        } catch (err) {
          console.log(err)
        }
      }).catch(err => console.log(err))
    },
    saveSchema(schema) {
      this.$db.collection('schemas').then(async schemas => {
        try {
          schema = _.cloneDeep(schema)
          schema._schema = schema.$schema
          delete schema.$schema
          delete schema._id
          await schemas.dUpdate({ name: schema.name }, schema)
          console.log('schema ' + schema.name + ' updated')
        } catch (err) {
          console.log(err)
        }
      }).catch(err => console.log(err))
    },
    handleEditMode(val) {
      this.editMode = val
    },
    handleSaveItem() {
      this.$db.collection('myitems').then(async myitems => {
        try {
          await myitems.dUpdate({ _id: this.selected._id }, this.selected)
          this.itemModified = true
        } catch (err) {
          console.log(err)
        }
      }).catch(err => console.log(err))
    },
    handleAddItem() {
      if (!this.schema) {
        this.$services.emit('app:notification', this.$t('You must define a schema first'))
        return
      }

      let gen = this.$utils.generateDataFormJSONSchema(this.schema)
      let item = gen.json
      // update schema for missongs like required and _meta
      this.schema = gen.schema
      this.saveSchema(this.schema)

      this.$router.push({
        path: '/item',
        query: {
          data: JSON.stringify(item),
          collection: 'myitems',
          schema: JSON.stringify(this.schema)
        }
      })
    },
    handleLoadSchema() {
      this.$router.push({
        path: '/list',
        query: {
          collection: 'schemas',
          backOnSelect: '/myitems'
        }
      })
    }
  },
  mounted() {
    this._listeners = {
      onEditMode: this.handleEditMode.bind(this),
      onAddItem: this.handleAddItem.bind(this),
      onLoadSchema: this.handleLoadSchema.bind(this)
    }

    let listEl = d3.select('#' + this.id).select('.list').node()
    listEl.addEventListener('scroll', this.handleScroll.bind(this))

    // wait for myitems data service
    this.$db.collection('myitems').then(myitems => {
      this.ready = true
      myitems.dFind({}).then(docs => {
        this.myitemsData = docs
        this.nextIndex = 0
        this.showNextElements()
      }).catch(err => console.log(err))
    }).catch(err => console.log(err))

    this.loadSchema()

    this.$services.emit('app:context:bar', 'myitems-ctx')

    this.$services.on('view:myitems:edit', this._listeners.onEditMode)
    this.$services.on('view:myitems:add', this._listeners.onAddItem)
    this.$services.on('view:schema:load', this._listeners.onLoadSchema)
  },
  beforeDestroy() {
    this.$services.emit('app:context:bar', null)
    this.$services.off('view:myitems:edit', this._listeners.onEditMode)
    this.$services.off('view:myitems:add', this._listeners.onAddItem)
    this.$services.off('view:schema:load', this._listeners.onLoadSchema)
  }
}
</script>

<style>
.myitems-layout {
  height: calc(100% - 0px);
}

.left-panel {
  height: calc(100% - 0px);
}

.right-panel {
  height: calc(100% - 0px);
}

.user-settings {
  height: calc(100% - 0px);
  flex: 1;
}

.actions-bar {
  margin-right: -40px;
  transition: margin-right 1s ease;
}

.actions-bar.open {
  margin-right: 0;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 1s;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
