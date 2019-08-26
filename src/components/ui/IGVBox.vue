<template>
  <ig-box class="tw-flex-col" :verticalFill="verticalFill">
    <slot></slot>
  </ig-box>
</template>

<script>
export default {
  name: 'ig-vbox',
  props: {
    verticalFill: {
      type: Boolean
    }
  }
}
</script>
