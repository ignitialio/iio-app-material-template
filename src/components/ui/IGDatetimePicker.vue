<template>
  <div class="dtp-layout tw-flex tw-flex-col tw-m-2"
    :class="{
      'tw-bg-gray-200 hover:tw-bg-gray-200': readonly && !disabled,
      'hover:tw-bg-gray-100': !readonly && !disabled
    }">

    <label v-if="label"
      class="dtp-label tw-top-0 tw-left-0 tw-text-xs tw-select-none"
      :class="{
        'tw-text-gray-400': disabled,
        'tw-text-yellow-600': !disabled
      }">{{ label }}</label>

    <flat-pickr
      class="dtp-input tw-outline-none tw-bg-transparent tw-text-gray-700"
      :class="{
        'tw-border-yellow-300': !disabled,
        'tw-border-gray-300': disabled,
        'hover:tw-text-yellow-700 focus:tw-border focus:tw-border-yellow-600': !readonly && !disabled,
        'tw-text-gray-300': disabled
      }"
      v-model="date" :config="config"></flat-pickr>
  </div>
</template>

<script>
import _ from 'lodash'
import * as d3 from 'd3'

import flatPickr from 'vue-flatpickr-component'
import 'flatpickr/dist/flatpickr.css'

// localization is optional
import {French} from 'flatpickr/dist/l10n/fr.js'
import {Spanish} from "flatpickr/dist/l10n/es.js"

export default {
  name: 'ig-datetime-picker',
  props: {
    value: {},
    type: {
      type: String,
      default: 'datetime'
    },
    readonly: {
      type: Boolean
    },
    disabled: {
      type: Boolean
    },
    label: {
      type: String
    }
  },
  watch: {
    date: function(val, old) {
      if (this.startDateWatching) {
        this.$emit('input', val)
        console.log('date change', old, val)
      }
    }
  },
  data() {
    return {
      date: null,
      // Get more form https://chmln.github.io/flatpickr/options/
      config: {
        altFormat: 'M j, Y H:i:s',
        altInput: true,
        dateFormat: 'd/m/Y',
        enableTime: true
      }
    }
  },
  components: {
    flatPickr
  },
  mounted() {
    this.date = _.cloneDeep(this.value)
    setTimeout(() => {
      this.startDateWatching = true
    })

    switch (this.type) {
      case 'date':
        this.config.enableTime = false
        break
      case 'time':
        break
      default:
        this.config.dateFormat = 'd/m/Y H:i:s'
    }

    switch (this.$i18n._language.split('-')[0]) {
      case 'fr':
        this.config.locale = French
        break
      case 'es':
        this.config.locale = Spanish
        break
    }

    d3.select(this.$el).selectAll('input')
      .classed('dtp-input', true)
      .classed('dtp-input:hover', true)
      .style('border-bottom', '1px solid #faf089')
  }
}
</script>

<style scoped>
.dtp-layout {
  background-color: transparent;
  width: calc(100% - 1em);
  height: 3em;
}

.dtp-layout:hover {
  background-color: #f7fafc;
}

.dtp-input {
  color: #4a5568;
  border: 1px solid #faf089!important;
}

.dtp-input:hover {
  border: 1px solid #d69e2e;
}

@media screen and (max-width: 800px) {

}
</style>
