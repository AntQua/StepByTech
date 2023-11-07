import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-form"
export default class extends Controller {
  static targets = ["associationNone", "associationEvent", "associationProgram", "associationStep", "eventSelect", "programSelect", "stepsSelect"]

  connect() {
    console.log("Post form controller connected");

    // Add an event listener to the program select dropdown to update steps
    this.programSelectTarget.addEventListener('change', this.updateSteps.bind(this));
  }

  // Handle radio button change event
  handleAssociationChange(event) {
    // Hide all association-specific fields initially
    this.eventSelectTarget.style.display = 'none';
    this.programSelectTarget.style.display = 'none';
    this.stepsSelectTarget.style.display = 'none';

    // Show the appropriate association-specific field based on the selected radio button
    switch (event.target.value) {
      case 'event':
        this.eventSelectTarget.style.display = 'block';
        break;
      case 'program':
        this.programSelectTarget.style.display = 'block';
        break;
      case 'step':
        this.programSelectTarget.style.display = 'block';
        // Additional logic may be needed here to handle steps based on programs.
        break;
      case 'none':
      default:
        // No association selected, so nothing else to do.
        break;
    }
  }

  // Fetch and update steps dropdown based on the selected program
  updateSteps() {
    const programId = this.programSelectTarget.value;

    if (programId) {
      const url = `/posts/steps_for_program?program_id=${programId}`;

      fetch(url)
        .then(response => response.json())
        .then(data => {
          this.updateStepsDropdown(data);
        })
        .catch(error => {
          console.error(error);
        });
    } else {
      // If no program is selected, clear the steps dropdown
      this.updateStepsDropdown([]);
    }
  }

  // Update the steps dropdown with the provided steps data
  updateStepsDropdown(steps) {
    const stepsSelect = this.stepsSelectTarget;
    stepsSelect.innerHTML = ""; // Clear previous options

    // Add the new options
    if (steps.length > 0) {
      steps.forEach(step => {
        const option = document.createElement("option");
        option.value = step.id;
        option.textContent = step.name_with_order;
        stepsSelect.appendChild(option);
      });
    }
  }
}

