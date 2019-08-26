<template>
  <div class="checkbox-layout tw-m-2"
    :class="{
      'tw-bg-gray-200 hover:tw-bg-gray-200': readonly && !disabled,
      'hover:tw-bg-gray-100': !readonly && !disabled
    }">

    <input class="css-checkbox"
      :readonly="readonly" :disabled="disabled"
      :checked="value" type="checkbox"/>

    <label
      @click="handleInput"
      class="css-label checkbox--label tw-select-none tw-text-gray-700"
      :class="{
        'tw-text-gray-400': disabled,
        'hover:tw-text-yellow-600': !disabled
      }">
      {{ label }}
    </label>

  </div>
</template>

<script>
export default {
  name: 'ig-checkbox',
  props: {
    value: {},
    type: {
      type: String,
      default: 'text'
    },
    label: {
      type: String,
      default: ''
    },
    readonly: {
      type: Boolean
    },
    disabled: {
      type: Boolean
    }
  },
  methods: {
    handleInput() {
      this.$emit('input', !this.value)
    }
  },
  mounted() {

  },
  computed: {
  }
}
</script>

<style scoped>
input[type=checkbox].css-checkbox {
	position:absolute;
  z-index: -1000;
  left: -1000px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  height: 1px;
  width: 1px;
  margin: -1px;
  padding: 0;
  border: 0;
}

input[type=checkbox].css-checkbox + label.css-label {
	padding-left: 33px;
	height: 28px;
	display: inline-block;
	line-height: 28px;
	background-repeat: no-repeat;
	background-position: 0 0;
	vertical-align: middle;
	cursor: pointer;
}

input[type=checkbox].css-checkbox:checked + label.css-label {
	background-position: 0 -28px;
}

label.css-label {
  background-image: url(~/assets/icons/csscheckbox.png);
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

@media screen and (max-width: 800px) {

}
</style>
