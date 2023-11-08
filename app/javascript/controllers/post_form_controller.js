import { Controller } from "@hotwired/stimulus";

export default class PostFormController extends Controller {
  //static targets = ["associationNone", "associationEvent", "associationProgram", "associationStep", "eventFields", "programFields", "stepFields", "stepsForProgram", "programSelect", "stepsSelect"];
  static targets = ["associationNone", "associationEvent", "associationProgram", "associationStep", "eventFields", "programFields", "stepFields", "program", "step"];

  connect() {
    console.log("Post form controller connected");
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
        //this.updateStepsForStep(); // Trigger step update for step
        break;
      case 'none':
      default:
        // No association selected, so nothing else to do.
        break;
    }
  }
}
