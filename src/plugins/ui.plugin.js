import IGIconSwitch from '../components/ui/IGIconSwitch.vue'
import IGFileInput from '../components/ui/IGFileInput.vue'
import IGProgressBar from '../components/ui/IGProgressBar.vue'
import IGForm from '../components/ui/IGForm.vue'
import IGGeo from '../components/ui/IGGeo.vue'
import IGDatetimePicker from '../components/ui/IGDatetimePicker.vue'

import IGFormSettings from '../components/ui/utils/IGFormSettings.vue'

export default {
  install:
    function (Vue) {
      Vue.component('ig-iconswitch', IGIconSwitch)
      Vue.component('ig-fileinput', IGFileInput)
      Vue.component('ig-progressbar', IGProgressBar)
      Vue.component('ig-form', IGForm)
      Vue.component('ig-geo', IGGeo)
      Vue.component('ig-datetime-picker', IGDatetimePicker)

      Vue.component('ig-form-settings', IGFormSettings)
    }
}
