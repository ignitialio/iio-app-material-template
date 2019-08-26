<template>
  <div class="input-layout tw-flex tw-m-2"
    :class="{
      'tw-bg-gray-200 hover:tw-bg-gray-200': readonly && !disabled && !button,
      'hover:tw-bg-gray-100': !readonly && !disabled && !button
    }">

    <ig-iconbutton class="trigger"
      :disabled="disabled" :type="button ? 'arrow_upward' : 'attach_file'"></ig-iconbutton>

    <div v-if="!button" class="drop-target tw-flex tw-flex-col">
      <label v-if="label"
        class="input-label tw-top-0 tw-left-0 tw-text-xs tw-select-none"
        :class="{
          'tw-text-gray-400': disabled,
          'tw-text-yellow-600': !disabled,

        }">{{ label }} {{ showThumbnail }}</label>

      <input readonly :disabled="disabled"
        class="tw-outline-none t-h-8 tw-bg-transparent
          tw-border-b tw-text-gray-700"
        :class="{
          'tw-border-yellow-300': !disabled,
          'tw-border-gray-300': disabled,
          'hover:tw-text-yellow-700 focus:tw-border focus:tw-border-yellow-600': !readonly && !disabled,
          'tw-text-gray-300': disabled
        }"
        :value="value"
        type="text"/>
    </div>

    <img v-if="showThumbnail && !button" :src="value"
      class="tw-ml-1 tw-border tw-border-yellow-300 tw-w-12 tw-h-12"/>
  </div>
</template>

<script>
import * as d3 from 'd3'
import Flow from '@flowjs/flow.js'

import ss from 'socket.io-stream'

export default {
  name: 'ig-fileinput',
  props: {
    value: {},
    type: {
      type: String,
      default: 'text'
    },
    label: {
      type: String
    },
    readonly: {
      type: Boolean
    },
    disabled: {
      type: Boolean
    },
    showThumbnail: {
      type: Boolean
    },
    button: {
      type: Boolean
    },
    s3: {
      type: Boolean
    },
    loadToBrowser: {
      type: Boolean
    }
  },
  methods: {
    handleFileSelection(event) {
      console.log(event)
      this.$emit('input', event.target.value)
    },
    streamFile(file) {
      let stream = ss.createStream()

      // upload a file to the server.
      ss(this.$ws.socket).emit('ws:file:upload', stream, {
        name: file.name,
        size: file.size,
        bucket: this.$utils.bucket.name,
        userId: this.$store.state.user._id
      })

      let blobStream = ss.createBlobReadStream(file)

      let size = 0

      blobStream.on('data', chunk => {
        size += chunk.length
        file.progress = parseInt(size / file.size * 100)
        this.$forceUpdate()

        let loaded = []
        for (let f of this.filesToUpload) {
          if (f.progress === 100) {
            loaded.push(f)
          }
        }
        this.$emit('input', loaded)
      })

      blobStream.pipe(stream)
    }
  },
  mounted() {
    var flow = new Flow({
      target: '/api/upload',
      query: {
        token: localStorage.getItem('token')
      }
    })

    if (!flow.support) {
      console.log('Flow not supported !')
    }

    flow.assignBrowse(d3.select(this.$el).select('.trigger').node())
    if (!this.button) {
      flow.assignDrop(d3.select(this.$el).select('.drop-target').node())
    }

    flow.on('fileAdded', (file, event) => {
      console.log(file, event)
      this.$emit('input', file.name)
    })

    flow.on('fileSuccess', (file, message) => {
      this.$services.emit('app:notification',
        this.$t('`File ${ params[0] } uploaded`', file.name))

      if (this.button) {
        flow.cancel()
        this.$services.emit('app:progress:show', false)
      }
    })

    flow.on('filesSubmitted', files => {
      if (this.button) {
        this.$services.emit('app:progress:show', true)
      }

      if (!this.loadToBrowser && !this.s3) {
        flow.upload()
      } else if (this.loadToBrowser) {
        for (let file of files) {
          let reader = new FileReader()

          reader.onload = evt => {
            this.$emit('load', evt.target.result)
            
            this.$services.emit('app:progress:show', false)
          }

          // is Flow file, so get file attribute
          reader.readAsText(file.file)
        }
      } else if (this.s3) {

      }
    })

    flow.on('fileProgress', file => {
      this.$services.emit('app:progress', file.progress()*100)
    })

    flow.on('fileError', (file, message) => {
      console.log('FLOW FILE ERROR', file, message)
    })

    flow.on('error', (file, message) => {
      console.log('FLOW ERROR', file, message)
    })
  },
  computed: {
  }
}
</script>

<style scoped>
.input-pwd {
  width: 177px;
}

.drop-target {
  flex: 1;
}

@media screen and (max-width: 800px) {

}
</style>
