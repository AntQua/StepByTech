import { Controller } from "@hotwired/stimulus";

export default class PostFormController extends Controller {
  static targets = ["associationNone", "associationEvent", "associationProgram", "associationStep", "eventFields", "programFields", "stepFields", "program", "step"];

  connect() {
    console.log("Post form controller connected");
    this.setInitialAssociationDisplay();
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
        break;
      case 'none':
      default:
        // No association selected, so nothing else to do.
        break;
    }
  }

  setInitialAssociationDisplay() {
    const associationType = this.getCurrentAssociationType();
    this.handleAssociationChange({ target: { value: associationType } });
  }

  getCurrentAssociationType() {
    // Use standard JavaScript to check if the element exists in the DOM
    if (this.element.querySelector('[data-post-form-target="associationEvent"]') && this.associationEventTarget.checked) {
      return 'event';
    } else if (this.element.querySelector('[data-post-form-target="associationProgram"]') && this.associationProgramTarget.checked) {
      return 'program';
    } else if (this.element.querySelector('[data-post-form-target="associationStep"]') && this.associationStepTarget.checked) {
      return 'step';
    } else {
      return 'none';
    }
  }

  updateSteps() {
    const programId = this.programTarget.value;
    const stepSelect = document.getElementById('post_step_id');

    // Clear current options in steps select
    stepSelect.innerHTML = '';

    // Fetch the steps based on the selected program
    fetch(`/programs/${programId}/steps`)
      .then(response => response.json())
      .then(data => {
        data.forEach((step) => {
          const option = document.createElement('option');
          option.value = step.id;
          option.text = step.name;
          stepSelect.appendChild(option);
        });
      })
      .catch(error => console.log(error));
  }

}
