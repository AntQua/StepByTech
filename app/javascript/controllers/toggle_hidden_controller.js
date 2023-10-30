import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["element"];
  static values = { selected: String }

  toggle() {
    this.elementTargets.forEach((element) => {
      element.classList.toggle('hidden');
    });
  }

  handleEventChange(event) {
    const selectedValue = event.target.value;
    this.elementTargets.forEach((element, index) => {
      if (index == 0 && selectedValue == this.selectedValue) {
        element.classList.remove('hidden');
      } else if (index == 1 && selectedValue != this.selectedValue) {
        element.classList.remove('hidden');
      } else {
        element.classList.add('hidden');
      }
    });
  }
}

