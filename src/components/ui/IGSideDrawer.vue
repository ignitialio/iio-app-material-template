<template>
  <div v-if="$store.state.user"
    class="tw-absolute tw-w-screen tw-h-screen tw-pointer-events-none">
    <div class="modal tw-absolute tw-z-10
      tw-w-screen tw-h-screen" :class="{ 'open': value }"
      @click="handleClose"></div>

    <div class="drawer tw-absolute tw-h-full tw-top-0 tw-z-20
      tw-pointer-events-auto
      tw-bg-white tw-shadow" :class="{ 'open': value }">

      <div v-if="header"
        class="tw-w-full tw-h-24 tw-bg-yellow-600 tw-flex">
        <div v-if="$store.state.user"
          class="tw-m-2 tw-w-12 tw-h-12 tw-overflow-hidden tw-rounded-full">
          <img class="tw-w-12 tw-h-12"
            :src="$store.state.user.picture.medium"/>
        </div>

        <div class="tw-m-2 tw-text-gray-200">
          <div class="tw-flex tw-items-center tw-text-lg">
            <div>{{ user.name.first + ' ' + user.name.last }}</div>
            <i v-if="user.role === 'admin'"
              class="tw-ml-4 material-icons">supervisor_account</i>
          </div>
          <div class="tw-text-sm">{{ user.email }}</div>
        </div>
      </div>

      <ig-list>
        <ig-menuitem v-if="!item.hidden"
          v-for="(item, index) in menuItems" :key="index"
          :item="item" @select="handleSelect"></ig-menuitem>
      </ig-list>
    </div>
  </div>
</template>

<script>
import _ from 'lodash'

export default {
  name: 'ig-sidedrawer',
  props: {
    /* manage open/close status */
    value: {
      type: Boolean,
      default: false
    },
    header: {
      type: Boolean,
      default: true
    },
    menuItems: {
      type: Array
    },
    user: Object
  },
  data: () => {
    return {
    }
  },
  methods: {
    handleClose() {
      // close drawer
      this.$emit('input', false)
    },
    handleSelect(item) {
      // close drawer
      this.$emit('input', false)

      let itemsToUnselect = _.filter(this.menuItems, e => e.title !== item.title)

      if (itemsToUnselect) {
        _.each(itemsToUnselect, e => {
          e.selected = false
        })
      }

      // if associated route
      if (item.route && item.route.path) {
        console.log(item.route.path)
        this.$router.push(item.route.path)
      }

      // if event to trig
      if (item.event) {
        this.$services.emit(item.event)
      }
    }
  },
  mounted() {
  },
  beforeDestroy() {
  }
}
</script>

<style scoped>
.drawer {
  width: 300px;
  left: -300px;
  background-color: rgba(255, 255, 255, 0.75);
  transition: left 1s ease;
}

.drawer.open {
  left: 0;
}

.modal {
  pointer-events: none;
}

.modal.open {
  pointer-events: auto;
}

@media screen and (max-width: 800px) {

}
</style>
