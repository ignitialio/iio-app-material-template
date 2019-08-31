import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'

var storeInstance

export function getStore(Vue) {
  if (storeInstance) return storeInstance

  Vue.use(Vuex)

  const state = {
    user: null,
    menuItems: [],
    connected: false,
    ui: {
      darkTheme: false,
      flatToolbar: true,
      toolbarColor: 'transparent'
    }
  }

  const mutations = {
    user(state, value) {
      state.user = value
    },
    menuItems(state, value) {
      state.menuItems = value
    },
    connected(state, value) {
      state.connected = value
    },
    ui(state, value) {
      state.ui = value
    }
  }

  const actions = {}

  storeInstance = new Vuex.Store({
    state,
    mutations,
    actions,
    plugins: [ createPersistedState() ]
  })

  return storeInstance
}
