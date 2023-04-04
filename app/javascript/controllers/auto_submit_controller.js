import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-submit"
export default class extends Controller {
  static targets = ['input'];
  static values = { delay: Number };

  connect() {
    this.delay = this.delayValue || 2000;
    this.timeoutId = 0;
  }

  trigger(event) {
    this.cancel();
    this.timeoutId = setTimeout(() => this.submit(), this.delay)
  }

  submit() {
    this.element.requestSubmit();
  }

  cancel() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }
}
