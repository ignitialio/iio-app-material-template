<template>
  <div :id="id" class="users-layout tw-w-full tw-flex">
    <div class="left-panel tw-w-full lg:tw-w-1/3 tw-relative">
      <ig-progressbar v-if="loading"
        indeterminate class="tw-absolute"></ig-progressbar>
      <ig-list class="list">
        <ig-listitem v-for="(user, index) in users" :key="index"
          :item="user" @select="handleSelect" :selected="selected === user"
          :title="user.name.first + ' ' + user.name.last"
          :subtitle="user.email"
          :picture="user.picture.medium"
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
        :class="{ 'open': userModified || schemaModified}">
        <ig-iconbutton v-if="editMode && schemaModified"
          type="save_alt" size="small"
          @click="handleSaveSchema"></ig-iconbutton>

        <ig-iconbutton v-if="userModified"
          type="save_alt" size="small"
          @click="handleSaveUser"></ig-iconbutton>
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
      users: [],
      selected: null,
      loading: false,
      schema: null,
      schemaModified: false,
      userModified: false,
      editMode: false
    }
  },
  watch: {
    selected: {
      handler: function(val) {
        if (!this.schema) {
          this.schema = this.$utils.generateJSONSchema('user', val)
          this.schemaModified = true
        }

        if ($j(val) !== this.lastUserChksum) {
          this.lastUserChksum = $j(val)
          this.userModified = true
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
      this.users = _.concat(this.users,
        _.slice(this.usersData, this.nextIndex, this.nextIndex + 100))
      this.nextIndex += 100
      setTimeout(() => this.loading = false, 500)
    },
    async handleSelect(item) {
      this.lastUserChksum = $j(item)
      this.userModified = false
      this.selected = item
    },
    handleSaveSchema() {
      this.$db.collection('schemas').then(async schemas => {
        try  {
          let schema = _.cloneDeep(this.schema)
          schema._schema = this.schema.$schema
          delete schema.$schema

          let usersSchema = await schemas.dGet({ name: 'users' })

          if (usersSchema) {
            let response = await schemas.dUpdate({ name: 'users' }, {
              name: 'users',
              schema: schema
            })

            console.log('users schema updated', response)
          } else {
            let response = schemas.dPut({
              name: 'users',
              schema: schema
            })

            console.log('users schema created', response)
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
          let usersSchema = await schemas.dGet({ name: 'users' })

          if (usersSchema) {
            // manage naming restrictions for Mongo
            usersSchema.schema.$schema = usersSchema.schema._schema
            delete usersSchema.schema._schema
            this.schema = usersSchema.schema
            this.lastSchemaChksum = $j(this.schema)
            setTimeout(() => this.schemaModified = false, 50)
          } else {
            console.log('no users schema saved')
          }
        } catch (err) {
          console.log(err)
        }
      }).catch(err => console.log(err))
    },
    handleEditMode(val) {
      this.editMode = val
    },
    handleSaveUser() {
      this.$db.collection('users').then(async users => {
        try {
          await users.dUpdate({ _id: this.selected._id }, this.selected)
          this.userModified = false
        } catch (err) {
          console.log(err)
        }
      }).catch(err => console.log(err))
    }
  },
  mounted() {
    this._listeners = {
      onEditMode: this.handleEditMode.bind(this)
    }

    let listEl = d3.select('#' + this.id).select('.list').node()
    listEl.addEventListener('scroll', this.handleScroll.bind(this))

    // wait for users data service
    this.$db.collection('users').then(users => {
      this.ready = true
      users.dFind({}).then(docs => {
        this.usersData = docs
        this.nextIndex = 0
        this.showNextElements()
      }).catch(err => console.log(err))
    }).catch(err => console.log(err))

    this.loadSchema()

    this.$services.emit('app:context:bar', 'users-ctx')

    this.$services.on('view:users:edit', this._listeners.onEditMode)
  },
  beforeDestroy() {
    this.$services.emit('app:context:bar', null)
    this.$services.off('view:users:edit', this._listeners.onEditMode)
  }
}
</script>

<style>
.users-layout {
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
