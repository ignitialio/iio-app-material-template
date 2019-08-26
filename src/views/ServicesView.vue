<template>
  <div class="services-layout tw-flex tw-w-full">
    <ig-list class="tw-w-1/4 tw-m-1 tw-shadow t-h-full">
      <ig-listitem v-for="(service, index) in services" :key="index"
        :item="service" @select="selected = $event"
        :title="service.name"
        :subtitle="service.options && service.options.description ? service.options.description.title : null"
        @mounted="handleMounted(service)"
        :picture="service._iconUrl">
      </ig-listitem>
    </ig-list>

    <div class="tw-w-3/4 tw-p-1">
      <component :is="selected.name"
        class="services-component tw-shadow"
        v-if="selected && selected.options.uiComponentInjection"></component>
    </div>
  </div>
</template>

<script>
import _ from 'lodash'

export default {
  data: () => {
    return {
      selected: null,
      services: null
    }
  },
  methods: {
    onServiceUp(service) {
      this.services = _.sortBy(_.values(this.$services.servicesDico), [ 'name' ])
      this.getImage(service, service.name, service.options.description.icon)
        .then(() => this.$forceUpdate())
        .catch(err => console.log(err))
    },
    onServiceDown(service) {
      this.services = _.sortBy(_.values(this.$services.servicesDico), [ 'name' ])
      if (this.selected && service === this.selected.name) {
        this.selected = null
      }
    },
    handleMounted(item) {
      if (item.options && item.options.description) {
        this.getImage(item, item.name, item.options.description.icon)
          .catch(err => console.log(err))
      }
    },
    getImage(itemToUpdate, serviceName, fileName) {
      return new Promise(async (resolve, reject) => {
        try {
          let imageData = await this.$services.getFileFromService(serviceName, fileName)
          let typedArray = new Uint8Array(imageData)
          let type = fileName.toLowerCase().match(/\.[0-9a-z]+$/i)[0].replace('.', '')
          if (type) {
            itemToUpdate._iconUrl = 'data:image/' + type + ';base64, ' +
              btoa(String.fromCharCode.apply(null, typedArray))
            this.$forceUpdate()
            resolve()
          }
        } catch (err) {
          reject(err)
        }
      })
    },
    handleSelect(service) {
      this.selected = service
    }
  },
  mounted() {
    // listeners
    this._listeners = {
      onServiceUp: this.onServiceUp.bind(this),
      onServiceDown: this.onServiceDown.bind(this)
    }
    this.$services.on('service:up', this._listeners.onServiceUp)
    this.$services.on('service:down', this._listeners.onServiceDown)

    this.services = _.sortBy(_.values(this.$services.servicesDico), [ 'name' ])

    this.$services.waitForService('iiost').then(iiost => {
      iiost.oneGetServiceMethod({ toto: 'titi' }).then(result => {
        console.log(result)
      }).catch(err => console.log(err))

      iiost.onePostServiceMethod({ toto: 'titi' }).then(result => {
        console.log(result)
      }).catch(err => console.log(err))
    }).catch(err => console.log(err))

    this.$db.collection('users').then(users => {
      users.dFind({ }).then(result => {
        console.log('users', result.length)
      }).catch(err => console.log(err))
    }).catch(err => console.log(err))
  },
  beforeDestroy() {
    this.$services.off('service:up', this._listeners.onServiceUp)
    this.$services.off('service:down', this._listeners.onServiceDown)
  }
}
</script>

<style scoped>
.services-layout {
  height: calc(100% - 0px);
}

.service-component {
  width: calc(100% - 24px);
  height: calc(100% - 24px);
}
</style>
