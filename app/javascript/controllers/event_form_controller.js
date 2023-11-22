import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["program", "step"];

  connect() {
    console.log("Event form controller connected");
    this.setInitialStep();
  }

  setInitialStep() {
    const programId = this.programTarget.value;
    const stepSelect = this.stepTarget;
    const currentStepId = stepSelect.dataset.currentStepId; // Assuming you have this data attribute in your view

    if (programId) {
      this.updateStepOptions(programId, currentStepId, stepSelect);
    } else {
      this.clearStepOptions(stepSelect);
    }
  }

  updateSteps() {
    const programId = this.programTarget.value;
    const stepSelect = this.stepTarget;

    if (programId) {
      this.updateStepOptions(programId, null, stepSelect);
    } else {
      this.clearStepOptions(stepSelect);
    }
  }

  updateStepOptions(programId, currentStepId, stepSelect) {
    stepSelect.disabled = true;

    fetch(`/programs/${programId}/all_steps.json`)
      .then(response => response.json())
      .then((data) => {
        this.populateStepOptions(data, stepSelect, currentStepId);
        stepSelect.disabled = false;
      })
      .catch(error => {
        console.log(error);
        this.clearStepOptions(stepSelect);
      });
  }

  populateStepOptions(steps, stepSelect, currentStepId) {
    this.clearStepOptions(stepSelect);

    steps.forEach((step) => {
      const option = document.createElement('option');
      option.value = step.id;
      option.textContent = step.name_with_order;
      if (currentStepId && step.id.toString() === currentStepId) {
        option.selected = true;
      }
      stepSelect.appendChild(option);
    });
  }

  clearStepOptions(stepSelect) {
    stepSelect.innerHTML = '<option value="">Nenhum (Sem associação a um Step)</option>';
    stepSelect.disabled = true;
  }
}

