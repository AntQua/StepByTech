import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["applyButton"];

  connect() {
    document.getElementById("applyForm").addEventListener("submit", async (event) => {
      event.preventDefault();
  
      const isValid = this.validateQuestions();
  
      if (isValid) {
        const result = await Swal.fire({
          icon: "question",
          title: "Confirmar Aplicação",
          text: "Tem certeza de que deseja enviar a aplicação para o programa?",
          showCancelButton: true,
          confirmButtonText: "Sim",
          cancelButtonText: "Não",
        });
  
        if (result.isConfirmed) {
          try {
            Swal.fire({
              icon: "success",
              title: "Aplicação Enviada!",
              text: "A sua aplicação foi enviada com sucesso.",
              timer: 4000,
              showConfirmButton: false,
            });

            event.target.submit();
            // window.location.href = "/dashboard";
            
          } catch (error) {
            console.error(error);
  
            Swal.fire({
              icon: "error",
              title: "Erro ao Enviar Aplicação",
              text: "Ocorreu um erro ao enviar a aplicação. Por favor, tente novamente mais tarde.",
            });
          }
        } else {
          Swal.fire("Cancelado", "A aplicação não foi enviada.", "info");
          return;
        }
      }
    });
  }
  

  conditionApply(event) {
    const agree = event.target.checked;
    if (agree) {
      this.applyButtonTarget.disabled = false;
    } else {
      this.applyButtonTarget.disabled = true;
    }
  }

  validateQuestions() {
    const validations = [];

    document.querySelectorAll("p[data-question-id]").forEach((question) => {
      const questionId = question.dataset.questionId;
      const questionType = question.dataset.questionType;
      let isValid = false;

      if (questionType == 0) {
        const answers = document.querySelectorAll(
          `textarea[data-question-id="${questionId}"]`
        );
        isValid = [...answers].some((answer) => answer.value.length > 0);
      } else {
        const answers = document.querySelectorAll(
          `input[data-question-id="${questionId}"]:checked`
        );

        isValid = answers.length > 0;
      }

      if (isValid === false) {
        question.classList.add("text-danger");
      } else {
        question.classList.remove("text-danger");
      }

      validations.push({ questionId, isValid });
    });

    const allIsValid = validations.every(
      (validation) => validation.isValid === true
    );

    if (!allIsValid) {
      Swal.fire({
        icon: "warning",
        title: "Aviso!",
        text: "Ainda há questões não respondidas. Por favor, complete todas as questões antes de prosseguir.",
      });
    }

    return allIsValid;
  }
}
