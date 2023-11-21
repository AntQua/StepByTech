import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkbox-limit"
export default class extends Controller {
  static values = {
    limit: Number
  }

  connect() {
  }

  handleCheckbox(event) {
    const limit = this.limitValue;
    if (this.element.querySelectorAll('input[type="checkbox"]:checked').length > limit) {
      event.target.checked = false;
    }
  }
}
