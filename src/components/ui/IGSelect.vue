<template>
  <div class="select-layout tw-p-2">
    <div class="select-layout--container
      tw-border tw-border-yellow-300
      tw-text-gray-700 hover:tw-text-yellow-700
      focus:tw-border focus:tw-border-yellow-600">
      <select class="tw-pt-4 tw-pl-4 tw-pr-8
        hover:tw-bg-gray-100 tw-outline-none tw-bg-transparent"
        :value="value" @change="handleChange">
        <option v-for="(opt, index) in values" :key="opt.value"
          :value="opt.value">{{ $t(opt.text) }}</option>
      </select>
    </div>

    <label v-if="label"
      style="top: 0.7em; left: 0.75em;"
      class="tw-absolute
        tw-text-xs tw-select-none
        tw-text-yellow-600">{{ label }}</label>
  </div>
</template>

<script>
import _ from 'lodash'

export default {
  name: 'ig-select',
  props: {
    value: {},
    type: {
      type: String,
      default: 'text'
    },
    label: {
      type: String
    },
    values: {
      type: Array
    }
  },
  data: () => {
    return {
    }
  },
  methods: {
    handleChange(event) {
      this.$emit('input', event.target.value)
    }
  },
  mounted() {

  },
  computed: {
  }
}
</script>

<style scoped>
.select-layout {
	position: relative;
}

.select-layout--container {
	position: relative;

	background-color: #fff;

	overflow: hidden;
	/*
		Le select natif pourra
		dépasser sans être vu
	*/
}

.select-layout--container select {
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;

	width: 100%;
	/*
		On est sûr de ne plus voir
		la flèche native
	*/

	height: auto;

  overflow-x: hidden;
	text-overflow: ellipsis;
  white-space: nowrap;
	/*
		On empêche le texte d'aller
		jusqu'au bout s'il est trop long
    BUG: no ellipsis showed
	*/
}

.select-layout--container::after {
	/* Le pointeur du select */
	content: '';
	position: absolute;
	top: 50%;
	margin-top: -3px;
	right: .75em;
	display: block;
	width: 0; height: 0;
	border-color: transparent;
	border-top-color: rgb(214, 158, 46);
	border-width: 6px;
	border-style: solid;
	pointer-events: none;
}

@media screen and (max-width: 800px) {

}
</style>
