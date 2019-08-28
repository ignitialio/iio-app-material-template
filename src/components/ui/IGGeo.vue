<template>
  <div class="geo-layout"
    :style="'height: ' + (height + 48) + 'px'">
    <vl-map ref="map" class="geo-map"
      :load-tiles-while-animating="true" :load-tiles-while-interacting="true"
      data-projection="EPSG:4326" :style="'height: ' + height + 'px'"
      @click="handleMapClick">
      <vl-view ref="view":zoom="zoom" :center.sync="mapCenter" :rotation="rotation"></vl-view>

      <vl-feature v-if="geoloc.position" id="position-feature">
        <vl-geom-point :coordinates="geoloc.position"></vl-geom-point>
        <vl-style-box>
          <vl-style-icon src="assets/markers/marker.png"
            :scale="0.4" :anchor="[0.5, 1]"></vl-style-icon>
        </vl-style-box>
      </vl-feature>

      <vl-layer-tile id="osm">
        <vl-source-osm></vl-source-osm>
      </vl-layer-tile>
    </vl-map>

    <div class="geo-actions">
      <v-btn icon class="geo-centering"
        @click.stop="handleUpdateCenter">
        <v-icon>gps_fixed</v-icon>
      </v-btn>
    </div>
  </div>
</template>

<script>
import _ from 'lodash'
import ResizeSensor from 'resize-sensor'

import Vue from 'vue'
import VueLayers from 'vuelayers'

import 'vuelayers/lib/style.css' // needs css-loader

Vue.use(VueLayers, {
  dataProjection: 'EPSG:4326',
})

export default {
  name: 'ig-geo',
  props: {
    marker: {},
    zoom: {
      type: Number,
      default: 8
    },
    rotation: {
      type: Number,
      default: 0
    },
    center: {
      type: Array,
      default: function() {
        return [ 9.689404, 39.987910 ]
      }
    },
    height: {
      type: Number,
      default: 400
    }
  },
  watch: {
    marker: function(val) {
      this.handleMarker(val)
    },
    mapCenter: function(val) {
      this.$emit('update:center', val)
    },
    geoloc: function(val) {
      console.log('MARKER', $j(val))
    }
  },
  data() {
    return {
      geoloc: { position: null },
      mapCenter: null
    }
  },
  methods: {
    handleMarker(val) {
      if (val) {
        if (Array.isArray(val)) {
          this.geoloc.position = val
        } else {
          this.geoloc.position =
            [ parseFloat(val.longitude), parseFloat(val.latitude) ]
        }

        if (!this.mapCenter) {
          this.mapCenter = this.geoloc.position

          console.log('MAP CENTER UPDATE', $j(this.mapCenter))
        }
      }
    },
    handleMapClick(e) {
      this.$emit('update:marker', e.coordinate)
    },
    handleUpdateCenter() {
      if (this.geoloc.position) {
        this.$refs.view.animate({
          center: this.geoloc.position,
          duration: 2000
        })
      }
    }
  },
  mounted() {
    this.resizeSensor = new ResizeSensor(this.$el, () => {
      this.$refs.map.updateSize()
    })

    console.log($j(this.marker))
    this.handleMarker(this.marker)

    if (!this.mapCenter) {
      view.animate({
        center: london,
        duration: 2000
      })
      this.mapCenter = _.cloneDeep(this.center)
      console.log('INITIAL MAP CENTER', $j(this.mapCenter))
    }
  }
}
</script>

<style scoped>
.geo-layout {
  display: flex;
  flex-flow: column;
}

.geo-map {
  top: 0;
  left: 0;
  border: 1px solid gainsboro;
}

.geo-acionts {
  width: 100%;
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.geo-centering {
  z-index: 50;
  position: absolute;
  bottom: 0;
  right: 0;
}
@media screen and (max-width: 800px) {

}
</style>
