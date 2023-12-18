import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "divulgation", "evaluation", "terms", "usage", "message"]

  connect() {
    this.toggleSubmitButton()
  }

  selectAll(event) {
    const isChecked = event.target.checked;
    // Use an array to iterate over targets if you have more than one of the same type
    const checkboxes = [this.usageTarget, this.divulgationTarget, this.evaluationTarget, this.termsTarget];
    checkboxes.forEach(checkbox => checkbox.checked = isChecked);

    this.toggleSubmitButton();
  }

  toggleSubmitButton() {
    const allRequiredConsentsGiven =
      this.usageTarget.checked &&
      this.evaluationTarget.checked &&
      this.termsTarget.checked;
    this.submitTarget.disabled = !allRequiredConsentsGiven;

    this.messageTarget.classList.toggle('d-none', allRequiredConsentsGiven);
  }
}
