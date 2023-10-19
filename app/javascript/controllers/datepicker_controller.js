import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt.js";

// Connects to data-controller="datepicker"
export default class extends Controller {
  connect() {
    console.log("Connecting datepicker...");

    const datePickerInputs = document.querySelectorAll(".datepicker");
    datePickerInputs.forEach((input) => {
      const mode = input.dataset.mode || "single"; //single, multiple, range
      const enableTime = input.dataset.enableTime || false; //true, false
      const dateFormat = input.dataset.dateFormat || "d/m/Y";

      const options = {
        mode,
        minDate: "today",
        enableTime,
        dateFormat,
        locale: Portuguese, // use Portuguese locale
      };

      if (mode == "multiple") {
        const defaultDate = input.dataset.initialValues
          ? input.dataset.initialValues.split(",")
          : [];
        options["defaultDate"] = defaultDate;
      }

      flatpickr(input, options);
    });
  }
}
