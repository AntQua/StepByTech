import { Controller } from "@hotwired/stimulus";

export default class PostFormController extends Controller {

    static targets = [
      "associationNone", "associationEvent", "associationProgram", "associationStep",
      "eventFields", "programFields", "stepFields",
      "eventSelect", "programSelect", "stepSelect",
      "programForStepSelect"
    ]

  connect() {
    //console.log("Post form controller connected");
    this.setInitialAssociationDisplay();
    // Call updateSteps if the association is 'step'
    if (this.getCurrentAssociationType() === 'step') {
      this.updateSteps();
    }
  }

  handleAssociationChange(event) {
    // Hide all association-specific fields initially
    this.eventFieldsTarget.style.display = 'none';
    this.programFieldsTarget.style.display = 'none';
    this.stepFieldsTarget.style.display = 'none';

    // Get the current association type
    const currentAssociationType = this.getCurrentAssociationType();

    // Reset selections for all associations except the current one
    this.resetSelections(currentAssociationType);

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
        this.updateSteps(); // Ensure steps are updated when the step association is selected
        break;
      case 'none':
      default:
        // No association selected, so nothing else to do.
        break;
    }
  }

  resetSelections(currentAssociationType) {
    if (currentAssociationType !== 'event' && this.eventSelectTarget) {
      this.eventSelectTarget.value = '';
    }
    if (currentAssociationType !== 'program' && this.programSelectTarget) {
      this.programSelectTarget.value = '';
    }
    if (currentAssociationType !== 'step' && this.stepSelectTarget) {
      this.stepSelectTarget.value = '';
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
    } else if (this.element.querySelector('[data-post-form-target="associationNone"]') && this.associationNoneTarget.checked) {
      return 'none';
    }
  }

  updateSteps() {

    const programId = this.programForStepSelectTarget.value;
    const stepSelect = this.stepSelectTarget;
    const currentStepId = this.element.querySelector('[data-post-step-id]').dataset.postStepId;

    // Clear current options in step select
    stepSelect.innerHTML = '';

    // Fetch the steps based on the selected program
    fetch(`/programs/${programId}/all_steps.json`)
      .then(response => response.json())
      .then(data => {
        data.forEach((step) => {
          const option = document.createElement('option');
          option.value = step.id;
          option.text = step.name_with_order;
          if (step.id.toString() === currentStepId) {
            option.selected = true;
          }
          stepSelect.appendChild(option);
        });
      })
      .catch(error => console.log(error));
  }

}
