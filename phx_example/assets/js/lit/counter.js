import { LitElement, css, html } from "lit";
import { customElement } from "lit/decorators.js";

@customElement("my-counter")
export class MyCounter extends LitElement {
  static styles = css`
    .container {
    }
  `;

  static properties = {
    count: { type: Number },
  };

  _handleInc() {
    this.dispatchEvent(new CustomEvent("increment"));
  }

  render() {
    return html`
      <div class="container">
        <button @click="${this._handleInc}">Increment</button>
        <span>${this.count}</span>
      </div>
    `;
  }
}
