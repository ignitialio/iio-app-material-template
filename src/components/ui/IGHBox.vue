<template>
  <ig-box :verticalFill="verticalFill">
    <slot></slot>
  </ig-box>
</template>

<script>
export default {
  name: 'ig-hbox',
  props: {
    verticalFill: {
      type: Boolean
    }
  }
}
</script>
