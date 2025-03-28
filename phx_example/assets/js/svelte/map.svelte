<script lang="ts">
  import { coordFromClick } from "../helpers/coordFromClick";

  let {
    marker,
    onSelectCoord,
  }: {
    marker: [number, number];
    onSelectCoord: (coord: [number, number]) => void;
  } = $props();

  const handleClick = (event) => {
    const coord = coordFromClick(event);
    onSelectCoord(coord);
  };
</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_static_element_interactions -->
<div class="container" onclick={handleClick} aria-label="map">
  <div
    class="marker"
    style="left: {marker[0]}%; top: calc(100% - {marker[1]}%)"
  ></div>
</div>

<style>
  .container {
    width: 200px;
    height: 200px;
    position: relative;
    border: 1px solid slategrey;
    border-radius: 4px;
  }

  .marker {
    width: 32px;
    height: 32px;
    margin-left: -16px;
    margin-top: -16px;
    background: url("https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Svelte_Logo.svg/1702px-Svelte_Logo.svg.png")
      no-repeat 50% 50%;
    background-size: contain;
    position: absolute;
  }
</style>
