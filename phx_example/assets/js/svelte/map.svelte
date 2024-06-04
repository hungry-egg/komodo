<script lang="ts">
  import { createEventDispatcher } from "svelte";
  import { coordFromClick } from "../helpers/coordFromClick";

  const dispatch = createEventDispatcher();

  export let marker;

  const handleClick = (event) => {
    const [x, y] = coordFromClick(event);
    dispatch("selectCoord", [x, y]);
  };
</script>

<!-- svelte-ignore a11y-unknown-aria-attribute -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<!-- svelte-ignore a11y-no-static-element-interactions -->
<div class="container" on:click={handleClick}>
  <div
    class="marker"
    style="left: {marker[0]}%; top: calc(100% - {marker[1]}%)"
  />
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
