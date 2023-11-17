import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["program", "step"]

  connect() {
    console.log("Event form controller connected");
  }

  updateSteps() {
    const programId = this.programTarget.value;
    const stepSelect = this.stepTarget;

    if (programId) {
      stepSelect.disabled = true;

      fetch(`/programs/${programId}/active_steps.json`)
        .then(response => response.json())
        .then((data) => {
          stepSelect.innerHTML = '<option value="">Nenhum (Sem associação a um Step)</option>';
          data.forEach((step) => {
            stepSelect.innerHTML += `<option value="${step.id}">${step.name_with_order}</option>`;
          });
          stepSelect.disabled = false;
        });
    } else {
      // Clear the steps dropdown and add the default option
      stepSelect.innerHTML = '<option value="">Nenhum (Sem associação a um Step)</option>';
      stepSelect.disabled = true; // Optionally disable the dropdown
    }
  }
}
