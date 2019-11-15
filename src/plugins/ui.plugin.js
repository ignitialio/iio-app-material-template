import IGIconSwitch from '../components/ui/IGIconSwitch.vue'
import IGFileInput from '../components/ui/IGFileInput.vue'
import IGFileLoadButton from '../components/ui/IGFileLoadButton.vue'
import IGForm from '../components/ui/IGForm.vue'
import IGGeo from '../components/ui/IGGeo.vue'

import IGJsonViewer from '../components/ui/utils/IGJsonViewer.vue'
import IGFormSettings from '../components/ui/utils/IGFormSettings.vue'
import IGSchemaManager from '../components/ui/utils/IGSchemaManager.vue'

import 'prismjs'
import 'prismjs/themes/prism.css'
import PrismEditor from 'vue-prism-editor'
import 'vue-prism-editor/dist/VuePrismEditor.css'

export default {
  install:
    function (Vue) {
      Vue.component('ig-iconswitch', IGIconSwitch)
      Vue.component('ig-fileinput', IGFileInput)
      Vue.component('ig-fileload-but', IGFileLoadButton)
      Vue.component('ig-form', IGForm)
      Vue.component('ig-geo', IGGeo)

      Vue.component('ig-form-settings', IGFormSettings)
      Vue.component('ig-json-viewer', IGJsonViewer)
      Vue.component('ig-schema-manager', IGSchemaManager)

      Vue.component('prism-editor', PrismEditor)
    }
}
