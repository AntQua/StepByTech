import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt.js";

export default class extends Controller {
  static targets = ["birthDate"]

  connect() {
    console.log("Connecting birthdate picker...");

    this.birthDateTargets.forEach((input) => {
      const dateFormat = input.dataset.dateFormat || "d/m/Y";

      const options = {
        dateFormat,
        locale: Portuguese, // Use Portuguese locale
        maxDate: new Date().fp_incr(-1), // Users should be at least 1 day old
        yearRange: [1900, new Date().getFullYear()] // Example year range from 1900 to current year
      };

      flatpickr(input, options);
    });
  }
}
