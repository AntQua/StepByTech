import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["applyButton"];

  connect() {
  }

  conditionApply(event) {
    const agree = event.target.checked;
    if(agree)
    {
      this.applyButtonTarget.disabled = false;
    }
    else {
      this.applyButtonTarget.disabled = true;
    }
  }

  toggleApplyButton() {
    console.log('toggle');
    const checkbox = this.element;
  
  }
}
