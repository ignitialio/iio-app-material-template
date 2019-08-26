<template>
  <div class="userctx-layout tw-w-full tw-flex tw-justify-end">
    <ig-iconswitch v-model="editMode" size="small" type="edit"
      :title="$t('Schema edit')"></ig-iconswitch>
  </div>
</template>

<script>
export default {
  name: 'ig-userctx',
  data: () => {
    return {
      editMode: false
    }
  },
  watch: {
    editMode: function(val) {
      this.$services.emit('view:users:edit', val)
    }
  },
  methods: {
  },
  mounted() {
  },
  computed: {
  }
}
</script>

<style scoped>
.userctx-layout {
  height: calc(100% - 0px);
}

@media screen and (max-width: 800px) {

}
</style>
