import { Controller } from "@hotwired/stimulus";

export default class PostFormController extends Controller {
  static targets = ["programId", "eventId", "stepId", "associationNone", "associationEvent", "associationProgram", "associationStep", "eventFields", "programFields", "stepFields", "program", "step"]

  connect() {
    console.log("Post form controller connected");
    this.setInitialAssociationDisplay();
  }

  // Reset the hidden fields based on the selected association type
  resetHiddenFields(associationType) {
    // Initially set all to empty
    this.programIdTarget.value = '';
    this.eventIdTarget.value = '';
    this.stepIdTarget.value = '';

    // Now set the value for the selected association, if applicable
    switch (associationType) {
      case 'event':
        this.eventIdTarget.value = this.getSelectValue('event');
        break;
      case 'program':
        this.programIdTarget.value = this.getSelectValue('program');
        break;
      case 'step':
        this.programIdTarget.value = this.getSelectValue('programForStep');
        this.stepIdTarget.value = this.getSelectValue('step');
        break;
    }
  }

  // Get the value of the select based on the association type
  getSelectValue(association) {
    const selectElement = this.element.querySelector(`[data-post-form-target="${association}Select"]`);
    return selectElement ? selectElement.value : '';
  }

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

    // Reset hidden fields based on selection
    this.resetHiddenFields(event.target.value);
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
