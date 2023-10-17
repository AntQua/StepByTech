import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["datePicker", "selectedDates", "datesArray"];

  connect() {
    console.log("date_adder_controller connected!");
  }

  addDate() {

    console.log("addDate method connected!");

    const selectedDate = this.datePickerTarget.value;

    if (selectedDate) {
      const listItem = document.createElement('li');
      listItem.textContent = selectedDate;

      const removeButton = document.createElement('button');
      removeButton.textContent = "Remove";
      removeButton.dataset.action = "click->date-adder#removeDate";
      listItem.appendChild(removeButton);
      this.selectedDatesTarget.appendChild(listItem);

      this.updateDatesArrayField();
    }
  }

  removeDate(event) {
    this.selectedDatesTarget.removeChild(event.target.parentElement);
    this.updateDatesArrayField();
  }

  updateDatesArrayField() {
    const dates = Array.from(this.selectedDatesTarget.children).map(li => li.textContent.split(" ")[0]);
    this.datesArrayTarget.value = dates.join(",");
  }
}
