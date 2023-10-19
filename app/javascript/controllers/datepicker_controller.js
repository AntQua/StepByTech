import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt.js";

// Connects to data-controller="datepicker"
export default class extends Controller {
  connect() {
    console.log("Connecting datepicker...");
    flatpickr(this.element, {
      minDate: "today",
      enableTime: false,
      dateFormat: "Y-m-d",
      "locale": Portuguese // use Portuguese locale
    });
  }
}
