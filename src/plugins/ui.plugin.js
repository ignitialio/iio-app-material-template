import IGIconButton from '../components/ui/IGIconButton.vue'
import IGIconSwitch from '../components/ui/IGIconSwitch.vue'
import IGIcon from '../components/ui/IGIcon.vue'
import IGSideDrawer from '../components/ui/IGSideDrawer.vue'
import IGToolbar from '../components/ui/IGToolbar.vue'
import IGList from '../components/ui/IGList.vue'
import IGMenuItem from '../components/ui/IGMenuItem.vue'
import IGListItem from '../components/ui/IGListItem.vue'
import IGListItemSlot from '../components/ui/IGListItemSlot.vue'
import IGInput from '../components/ui/IGInput.vue'
import IGFileInput from '../components/ui/IGFileInput.vue'
import IGCheckbox from '../components/ui/IGCheckbox.vue'
import IGPaper from '../components/ui/IGPaper.vue'
import IGProgressBar from '../components/ui/IGProgressBar.vue'
import IGForm from '../components/ui/IGForm.vue'
import IGSelect from '../components/ui/IGSelect.vue'
import IGTags from '../components/ui/IGTags.vue'
import IGDialog from '../components/ui/IGDialog.vue'
import IGBox from '../components/ui/IGBox.vue'
import IGHBox from '../components/ui/IGHBox.vue'
import IGVBox from '../components/ui/IGVBox.vue'
import IGGeo from '../components/ui/IGGeo.vue'
import IGDatetimePicker from '../components/ui/IGDatetimePicker.vue'
import IGNotification from '../components/ui/IGNotification.vue'

import IGFormSettings from '../components/ui/utils/IGFormSettings.vue'

export default {
  install:
    function (Vue) {
      Vue.component('ig-iconbutton', IGIconButton)
      Vue.component('ig-iconswitch', IGIconSwitch)
      Vue.component('ig-icon', IGIcon)
      Vue.component('ig-sidedrawer', IGSideDrawer)
      Vue.component('ig-toolbar', IGToolbar)
      Vue.component('ig-list', IGList)
      Vue.component('ig-menuitem', IGMenuItem)
      Vue.component('ig-listitem', IGListItem)
      Vue.component('ig-listitem-slot', IGListItemSlot)
      Vue.component('ig-input', IGInput)
      Vue.component('ig-checkbox', IGCheckbox)
      Vue.component('ig-fileinput', IGFileInput)
      Vue.component('ig-paper', IGPaper)
      Vue.component('ig-progressbar', IGProgressBar)
      Vue.component('ig-form', IGForm)
      Vue.component('ig-select', IGSelect)
      Vue.component('ig-tags', IGTags)
      Vue.component('ig-dialog', IGDialog)
      Vue.component('ig-box', IGBox)
      Vue.component('ig-hbox', IGHBox)
      Vue.component('ig-vbox', IGVBox)
      Vue.component('ig-geo', IGGeo)
      Vue.component('ig-datetime-picker', IGDatetimePicker)
      Vue.component('ig-notification', IGNotification)

      Vue.component('ig-form-settings', IGFormSettings)
    }
}
