<script setup>
import { onMounted } from 'vue';
import Identity from './components/Identity.vue'

const applyColors = (colors) => {
    if (!colors) return
    const root = document.documentElement

    if (colors.accent) root.style.setProperty('--accent', colors.accent)
    if (colors.accentDark) root.style.setProperty('--accent-dark', colors.accentDark)
    if (colors.accentGlow) root.style.setProperty('--accent-glow', colors.accentGlow)
    if (colors.female) root.style.setProperty('--female', colors.female)
    if (colors.femaleDark) root.style.setProperty('--female-dark', colors.femaleDark)
    if (colors.panelBgStart) root.style.setProperty('--panel-bg-start', colors.panelBgStart)
    if (colors.panelBgMid) root.style.setProperty('--panel-bg-mid', colors.panelBgMid)
    if (colors.inputBg) root.style.setProperty('--input-bg', colors.inputBg)
    if (colors.inputBgFocus) root.style.setProperty('--input-bg-focus', colors.inputBgFocus)
    if (colors.calendarBg) root.style.setProperty('--calendar-bg', colors.calendarBg)
}

onMounted(() => {
  fetch("http://esx_identity/ready", {
    method: "POST",
    body: JSON.stringify({}),
  });

  window.addEventListener("message", (event) => {
    if (event.data.type === "enableui") {
        document.body.classList[event.data.enable ? "remove" : "add"]("none");
        applyColors(event.data.colors);
    }
  });
})

</script>

<template>
  <Identity/>
</template>

<style scoped>

</style>