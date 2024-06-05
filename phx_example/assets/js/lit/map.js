import { LitElement, css, html } from "lit";
import { customElement, property } from "lit/decorators.js";
import { coordFromClick } from "../helpers/coordFromClick";

@customElement("my-map")
export class MyMap extends LitElement {
  static styles = css`
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
      background: url("https://user-images.githubusercontent.com/1007051/116786946-bd75c280-aaa1-11eb-859d-f929a6db1c04.png")
        no-repeat 50% 50%;
      background-size: contain;
      position: absolute;
    }
  `;

  static properties = {
    marker: { type: Array },
  };

  _handleClick(event) {
    const [x, y] = coordFromClick(event);
    this.dispatchEvent(new CustomEvent("select-coord", { detail: { x, y } }));
  }

  render() {
    return html`
      <div class="container" @click="${this._handleClick}">
        <div
          class="marker"
          style="left: ${this.marker[0]}%; top: calc(100% - ${this.marker[1]}%)"
        />
      </div>
    `;
  }
}
