import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class PostFormController extends Controller {
  static targets = ["associationNone", "associationEvent", "associationProgram", "associationStep", "eventFields", "programFields", "stepFields"]

  connect() {
    console.log("Post form controller connected");
    console.log("turbo:", Turbo);

    // Add event listeners for program and program for step selections
    this.programSelectTarget.addEventListener('change', this.updateSteps.bind(this));
    this.programSelectForStepTarget.addEventListener('change', this.updateStepsForStep.bind(this));
  }

  // Handle radio button change event
  handleAssociationChange(event) {
    // Hide all association-specific fields initially
    this.eventFieldsTarget.style.display = 'none';
    this.programFieldsTarget.style.display = 'none';
    this.stepFieldsTarget.style.display = 'none';

    // Show the appropriate association-specific field based on the selected radio button
    switch (event.target.value) {
      case 'event':
        this.eventFieldsTarget.style.display = 'block';
        break;
      case 'program':
        this.programFieldsTarget.style.display = 'block';
        break;
      case 'step':
        this.stepFieldsTarget.style.display = 'block';
        this.updateStepsForStep(); // Trigger step update for step
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

  // Fetch and update steps dropdown based on the selected program for steps
  updateStepsForStep() {
    const programIdForStep = this.programSelectForStepTarget.value;

    if (programIdForStep) {
      const url = `/posts/steps_for_program?program_id=${programIdForStep}`;

      fetch(url)
        .then(response => response.json())
        .then(data => {
          this.updateStepsDropdownForStep(data);
        })
        .catch(error => {
          console.error(error);
        });
    } else {
      // If no program is selected for steps, clear the steps dropdown for steps
      this.updateStepsDropdownForStep([]);
    }
  }

  // Update the steps dropdown for steps with the provided steps data
  updateStepsDropdownForStep(steps) {
    const stepsSelectForStep = this.stepsSelectForStepTarget;
    stepsSelectForStep.innerHTML = ""; // Clear previous options

    // Add the new options
    if (steps.length > 0) {
      steps.forEach(step => {
        const option = document.createElement("option");
        option.value = step.id;
        option.textContent = step.name_with_order;
        stepsSelectForStep.appendChild(option);
      });
    }
  }
}
