import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-form"
export default class extends Controller {
  static targets = ["associationNone", "associationEvent", "associationProgram", "associationStep", "eventSelect", "programSelect", "stepsSelect"]

  connect() {
    console.log("Post form controller connected");
  }

  handleAssociationChange(event) {
    this.eventSelectTarget.style.display = 'none';
    this.programSelectTarget.style.display = 'none';
    this.stepsSelectTarget.style.display = 'none';

    switch (event.target.value) {
      case 'event':
        this.eventSelectTarget.style.display = 'block';
        break;
      case 'program':
        this.programSelectTarget.style.display = 'block';
        break;
      case 'step':
        this.programSelectTarget.style.display = 'block';
        // Since steps are dependent on programs, you might need additional logic to handle this case.
        break;
      case 'none':
      default:
        // No association, so nothing else to do.
        break;
    }
  }

  updateSteps() {
    const programId = this.programSelectTarget.value;

    // Make sure you have a valid programId before attempting the AJAX request
    if (programId) {
      const url = `/programs/${programId}/steps_data`;

      Rails.ajax({
        type: "GET",
        url: url,
        success: (data) => {
          // The assumption here is that the server returns a partial
          // with options for the steps select dropdown
          this.stepsSelectTarget.innerHTML = data.body.innerHTML;
        },
        error: (error) => {
          console.log(error);
        }
      });
    } else {
      // Clear the steps select if no program is selected
      this.stepsSelectTarget.innerHTML = '';
    }
  }
}
