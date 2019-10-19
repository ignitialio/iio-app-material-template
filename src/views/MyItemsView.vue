<template>
  <div :id="id" class="myitems-layout">
    <div class="myitems-left-panel">
      <v-progress-linear v-if="loading"
        indeterminate class="myitems-list-progress-bar"></v-progress-linear>
      <v-list class="list">
        <v-list-item v-for="(item, index) in myitems" :key="index"
          @click.stop="handleSelect(item)"
          :class="{ 'selected': selected === item }">
          <v-list-item-avatar>
            <v-img :src="item.picture && item.picture.thumbnail ?
              $utils.fileUrl(item.picture.medium) :
              'assets/item.png'" alt=""></v-img>
          </v-list-item-avatar>

          <v-list-item-content>
            <v-list-item-title v-text="item.name.first + ' ' + item.name.last">
            </v-list-item-title>
            <v-list-item-subtitle v-text="item.location.postcode + ' ' +
              item.location.city"></v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </div>

    <div class="myitems-right-panel">
      <div class="myitems-settings">
        <ig-form v-if="!!selected && !!schema"
          v-model="selected" name="myitem" :schema.sync="schema"
          :editable="$store.state.user.role === 'admin' && editMode">
        </ig-form>
      </div>

      <div class="myitems-actions-bar"
        :class="{ 'open': itemModified || schemaModified}">
        <v-btn v-if="editMode && schemaModified" icon
          @click.stop="handleSaveSchema">
          <v-icon>save_alt</v-icon>
        </v-btn>

        <v-btn v-if="itemModified" icon @click.stop="handleSaveUser">
          <v-icon>save_alt</v-icon>
        </v-btn>
      </div>
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

        if (global.$j(val) !== this.lastItemChksum) {
          this.lastItemChksum = global.$j(val)
          this.itemModified = true
        }
      },
      deep: true
    },
    schema: {
      handler: function(val) {
        if (this.lastSchemaChksum !== global.$j(val)) {
          this.lastSchemaChksum = global.$j(val)
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
      setTimeout(() => { this.loading = false }, 500)
    },
    async handleSelect(item) {
      this.lastItemChksum = global.$j(item)
      this.itemModified = false
      this.selected = item
    },
    handleSaveSchema() {
      this.$db.collection('schemas').then(async schemas => {
        try {
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
            this.lastSchemaChksum = global.$j(this.schema)
            setTimeout(() => { this.schemaModified = false }, 50)
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
  width: 100%;
  height: calc(100% - 0px);
  display: flex;
}

.myitems-list-progress-bar {
  position: absolute;
  width: 100%;
}

.myitems-left-panel {
  position: relative;
  width: 33%;
  height: calc(100% - 0px);
}

.myitems-left-panel .list {
  height: calc(100% - 0px)!important;
  overflow-y: auto;
}

.myitems-right-panel {
  width: 67%;
  height: calc(100% - 0px);
  padding-left: 8px;
}

.myitems-settings {
  height: calc(100% - 0px);
  flex: 1;
}

.myitems-actions-bar {
  margin-right: -40px;
  width: 40px;
  height: calc(100% - 0px);
  display: flex;
  flex-flow: column;
  justify-content: flex-end;
  transition: margin-right 1s ease;
}

.myitems-actions-bar.open {
  margin-right: 0;
}
</style>
