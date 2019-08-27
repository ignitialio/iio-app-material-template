<template>
  <div :id="id" class="users-layout">
    <div class="users-left-panel">
      <v-progress-linear v-if="loading"
        indeterminate class="tw-absolute"></v-progress-linear>

      <v-list class="list">
        <v-list-item v-for="(item, index) in users" :key="index"
          @click.stop="handleSelect(item)"
          :class="{ 'selected': selected === user }">
          <v-list-item-avatar>
            <v-img :src="item.picture && item.picture.thumbnail ?
              $utils.fileUrl(item.picture.medium) :
              'assets/user.png'" alt=""></v-img>
          </v-list-item-avatar>

          <v-list-item-content>
            <v-list-item-title v-text="item.name.first + ' ' + item.name.last"></v-list-item-title>
            <v-list-item-subtitle v-text="item.email"></v-list-item-subtitle>
          </v-list-item-content>

          <v-list-item-action>
            <v-btn v-if="user && user.role === 'admin'" icon>
              <v-icon color="grey lighten-1">trash</v-icon>
            </v-btn>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </div>

    <div class="users-right-panel">
        <ig-form v-if="!!selected && !!schema"
          v-model="selected" name="user" :schema.sync="schema"
          :editable="user && user.role === 'admin' && editMode">
        </ig-form>
      </div>

      <div class="users-actions-bar tw-w-10 tw-justify-end tw-shadow" verticalFill
        :class="{ 'open': userModified || schemaModified}">
        <v-btn v-if="editMode && schemaModified" icon
          @click.stop="handleSaveSchema">
          <v-icon>save_alt</v-icon>
        </v-btn>

        <v-btn v-if="userModified" icon @click.stop="handleSaveUser">
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
  computed: {
    user() {
      return this.$store.state.user
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
      console.log(this.lastUserChksum)
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

<style sass>
.users-layout {
  width: 100%;
  height: calc(100% - 0px);
  display: flex;
  padding-top: 8px;
}

.users-left-panel {
  position: relative;
  width: 33%;
  height: calc(100% - 0px);
}

.users-left-panel .list {
  height: calc(100% - 0px)!important;
  overflow-y: auto;
}

.users-right-panel {
  width: 67%;
  height: calc(100% - 0px);
}

.users-user-settings {
  height: calc(100% - 0px);
  flex: 1;
}

.users-actions-bar {
  margin-right: -40px;
  width: 40px;
  display: flex;
  flex-flow: column;
  justify-content: flex-end;
  transition: margin-right 1s ease;
}

.users-actions-bar.open {
  margin-right: 0;
}

@media screen and (max-width: 800px) {
  .users-left-panel {
    width: 100%;
  }

  .users-right-panel {
    display: none;
  }
}
</style>
