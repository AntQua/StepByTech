import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["datePicker", "selectedDates", "datesArray"];

  // connect() {
  //   console.log("date_adder_controller connected!");
  // }

  addDate() {
    const selectedDate = this.datePickerTarget.value;
    const existingDates = [...this.element.querySelectorAll(`input[name="step[dates][]"]`)].map(input => input.value);

    if (selectedDate && !existingDates.includes(selectedDate)) {
        const listItem = document.createElement('li');
        listItem.textContent = selectedDate + " ";

        // Create a new hidden input field for the date
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'step[dates][]';
        hiddenInput.value = selectedDate;

        // Append the hidden input to the form
        this.element.appendChild(hiddenInput);

        const removeButton = document.createElement('button');
        removeButton.textContent = "Remove";
        removeButton.dataset.action = "click->date-adder#removeDate";
        listItem.appendChild(removeButton);
        this.selectedDatesTarget.appendChild(listItem);
    }
  }

  removeDate(event) {
    const dateValueToRemove = event.target.parentElement.textContent.trim().slice(0, 10);

    // Remove the corresponding hidden input
    const correspondingHiddenInput = [...this.element.querySelectorAll(`input[name="step[dates][]"]`)].find(input => input.value === dateValueToRemove);
    if (correspondingHiddenInput) {
      this.element.removeChild(correspondingHiddenInput);
    }

    // Remove the date from the list
    this.selectedDatesTarget.removeChild(event.target.parentElement);
  }
}

