<template>
  <div class="input-layout tw-flex tw-flex-col tw-m-2"
    :class="{
      'tw-bg-gray-200 hover:tw-bg-gray-200': readonly && !disabled,
      'hover:tw-bg-gray-100': !readonly && !disabled
    }">

    <label v-if="label"
      class="input-label tw-top-0 tw-left-0 tw-text-xs tw-select-none"
      :class="{
        'tw-text-gray-400': disabled,
        'tw-text-yellow-600': !disabled
      }">{{ label }}</label>

    <div class="tw-flex">
      <input v-if="type !== 'password' || (type === 'password' && !showPassword)"
        :readonly="readonly" :disabled="disabled"
        class="tw-w-full tw-outline-none t-h-8 tw-bg-transparent
          tw-border-b tw-text-gray-700"
        :class="{
          'tw-border-yellow-300': !disabled,
          'tw-border-gray-300': disabled,
          'hover:tw-text-yellow-700 focus:tw-border focus:tw-border-yellow-600': !readonly && !disabled,
          'tw-text-gray-300': disabled,
          'input-pwd': type === 'password'
        }"
        :value="value" @input="handleInput" @change="handleChange" @keyup="handleChange"
        :type="type"/>

      <input v-if="type === 'password' && showPassword"
        :readonly="readonly" :disabled="disabled"
        class="tw-outline-none t-h-8 tw-bg-transparent
          tw-border-b tw-text-gray-700"
        :class="{
          'tw-border-yellow-300': !disabled,
          'tw-border-gray-300': disabled,
          'hover:tw-text-yellow-700 focus:tw-border focus:tw-border-yellow-600': !readonly && !disabled,
          'tw-text-gray-300': disabled,
          'input-pwd': type === 'password'
        }"
        :value="value" @input="handleInput"
        type="text"/>

      <div v-if="type === 'password'"
        class="tw-flex tw-justify-center tw-items-center tw-cursor-pointer
          tw-text-gray-500">
        <i v-if="showPassword" class="material-icons tw-text-base tw-w-6"
          @click="showPassword = !showPassword">visibility_off</i>
        <i v-if="!showPassword" class="material-icons tw-text-base tw-w-6"
          @click="showPassword = !showPassword">visibility</i>
      </div>

      <div v-if="icon"
        class="tw-flex tw-justify-center tw-items-center tw-cursor-pointer
          tw-text-gray-500">
        <i class="material-icons tw-text-base tw-w-6">{{ icon }}</i>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ig-input',
  props: {
    value: {},
    type: {
      type: String,
      default: 'text'
    },
    label: {
      type: String
    },
    icon: {
      type: String
    },
    readonly: {
      type: Boolean
    },
    disabled: {
      type: Boolean
    }
  },
  data: () => {
    return {
      showPassword: false
    }
  },
  methods: {
    handleInput(event) {
      this.$emit('input', event.target.value)
    },
    handleChange(event) {
      this.$emit('change', event.target.value)
    }
  },
  mounted() {

  },
  computed: {
  }
}
</script>

<style scoped>
.input-pwd {
  width: 177px;
}

@media screen and (max-width: 800px) {

}
</style>
