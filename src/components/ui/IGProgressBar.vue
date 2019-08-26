<template>
  <div class="progress-bar tw-z-10 tw-bg-transparent tw-overflow-hidden
    tw-w-full">
    <div class="progress tw-bg-yellow-600 tw-overflow-hidden"
      :class="{ 'indeterminate': indeterminate }"></div>
  </div>
</template>

<script>
import * as d3 from 'd3'

export default {
  name: 'ig-progressbar',
  props: {
    value: Number,
    min: {
      type: Number,
      default: 0
    },
    max: {
      type: Number,
      default: 100
    },
    indeterminate: Boolean
  },
  watch: {
    value: function(val) {
      this.update()
    }
  },
  data: () => {
    return {
    }
  },
  methods: {
    update() {
      let width = 100 * this.value / (this.max - this.min)
      this.progressEl.style('width', width + '%')
    }
  },
  mounted() {
    this.progressEl = d3.select(this.$el).select('.progress')

    if (!this.indeterminate) {
      this.update()
    }
  },
  beforeDestroy() {

  }
}
</script>

<style scoped>
.progress-bar {
	border-radius: 4px;
  height: 4px;
}

.progress {
  left: 0;
	border-radius: 4px;
  transition: width 0.5s ease;
  height: 4px;
  width: 0;
}

.progress.indeterminate {
  animation: loader 8s ease infinite;
}

@keyframes loader {
	0% {
    left: 0;
		width: 0;
	}

	50% {
    left: 0;
		width: 100%;
	}

	100% {
    left: 100%;
		width: 0;
	}
}

@media screen and (max-width: 800px) {

}
</style>
