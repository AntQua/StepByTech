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
        locale: Portuguese,
        maxDate: new Date().fp_incr(-1),
        defaultDate: input.value, // Set the default date
      };

      flatpickr(input, options);
    });
  }
}
