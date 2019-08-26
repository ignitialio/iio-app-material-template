<template>
  <ig-dialog :value="value"
    :title="$t('Property detailed type')"
    :subtitle="name"
    width="60%" height="60%">
    <ig-vbox v-if="schema" verticalFill>
      <ig-hbox verticalFill>
        <ig-list class="settings-left tw-w-1/3">
          <!-- sub type -->
          <ig-listitem-slot v-if="schema.type === 'string'" class="tw-h-16">
            <ig-select v-if="schema._meta" :label="$t('Type')"
              :values="strTypes" v-model="schema._meta.type"></ig-select>
          </ig-listitem-slot>

          <ig-listitem-slot v-else-if="!isPrimitive" class="tw-h-16">
            <ig-select v-if="schema._meta" :label="$t('Type')"
              :values="objTypes" v-model="schema._meta.type"></ig-select>
          </ig-listitem-slot>

          <!-- string pattern -->
          <ig-listitem-slot v-if="schema.type === 'string'" class="tw-h-16">
            <ig-input :label="$t('Pattern')" v-model="schema._meta.pattern"/>
          </ig-listitem-slot>
        </ig-list>

        <ig-vbox class="settings-right tw-w-2/3 tw-p-1" verticalFill>
          <div class="enums tw-flex tw-flex-col tw-overflow-x-hidden
            tw-overflow-y-auto tw-mx-2"
            v-if="schema.enum && schema._meta.type === 'enum'">
            <div class="tw-flex tw-items-center"
              v-for="(item, index) in schema.enum" :key="index">
              <ig-iconbutton v-if="index === schema.enum.length - 1"
                type="add" color="green"
                @click="handleAddEnumItem"></ig-iconbutton>
              <div v-else class="tw-w-12 tw-h-6"></div>
              <ig-input class="tw-w-2/6"
                v-model="item.value" :label="$t('Value')"></ig-input>
              <ig-input v-model="item.text" :label="$t('Text')"></ig-input>
              <ig-iconbutton type="clear" color="red"
                @click="handleRemoveEnumItem"></ig-iconbutton>
            </div>
          </div>

          <!-- Item is File -->
          <div class="tw-flex tw-flex-col"
            v-else-if="schema._meta.type === 'file'">
            <ig-input v-model="schema._meta.maxSize" type="number"
              :label="$t('Max size')"></ig-input>

            <ig-input v-model="schema._meta.fileType"
              :label="$t('File type')"></ig-input>
          </div>

          <!-- Item is Image -->
          <div class="tw-flex tw-flex-col"
            v-else-if="schema._meta.type === 'image'">
            <ig-input v-model="schema._meta.maxSize" type="number"
              :label="$t('Max size')"></ig-input>

            <ig-select v-if="schema._meta" :label="$t('Image type')"
              :values="imageTypes" v-model="schema._meta.imageType"></ig-select>

            <ig-checkbox :label="$t('Show thumbnail')"
              v-model="schema._meta.showThumbnail"></ig-checkbox>
          </div>
        </ig-vbox>
      </ig-hbox>

      <ig-hbox class="tw-h-16 tw-justify-end tw-items-center">
        <ig-iconbutton type="check" color="green" @click="handleCloseSettings">
        </ig-iconbutton>
      </ig-hbox>
    </ig-vbox>
  </ig-dialog>
</template>

<script>
export default {
  name: 'ig-form-settings',
  props: {
    name: {
      type: String
    },
    value: {
      type: Boolean
    },
    schema: {}
  },
  data: () => {
    return {
      strTypes: [
        {
          value: 'enum',
          text: 'Enum'
        },
        {
          value: 'file',
          text: 'File'
        },
        {
          value: 'image',
          text: 'Image'
        },
        {
          value: 'date',
          text: 'Date format'
        },
        {
          value: 'time',
          text: 'Time format'
        },
        {
          value: 'datetime',
          text: 'Date and time format'
        },
        {
          value: null,
          text: ''
        }
      ],
      imageTypes: [
        {
          value: 'image/jpeg',
          text: 'JPEG'
        },
        {
          value: 'image/png',
          text: 'PNG'
        },
        {
          value: 'image/webp',
          text: 'WebP'
        },
        {
          value: 'image/svg+xml',
          text: 'SVG'
        },
        {
          value: 'image/*',
          text: 'All'
        }
      ],
      objTypes: [
        {
          value: 'geopoint',
          text: 'Geographical location'
        },
        {
          value: 'geoshape',
          text: 'Geographical shape'
        },
        {
          value: null,
          text: ''
        }
      ]
    }
  },
  methods: {
    handleAddEnumItem() {
      this._schema.enum.push({
        text: '',
        value: null
      })

      this.$emit('update:schema', this._schema)
      this.$forceUpdate()
    },
    handleRemoveEnumItem(item) {
      let index = this._schema.enum.indexOf(item)
      this._schema.enum.splice(index, 1)

      this.$emit('update:schema', this._schema)
    },
    handleCloseSettings() {
      this.$emit('input', false)
    }
  },
  computed: {
    isPrimitive() {
      if (this.schema.type === 'object' || this.schema.type === 'array') {
        return false
      }

      return true
    }
  },
  mounted() {

  }
}
</script>

<style scoped>
.settings-layout {

}

@media screen and (max-width: 800px) {

}
</style>
