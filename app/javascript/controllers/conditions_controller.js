import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["applyButton"];

  connect() {
    document.getElementById('applyForm').addEventListener('submit', (event) => {
      event.preventDefault();

      const isValid = this.validateQuestions();

      if(isValid){
        event.target.submit();
      }
      else
        return;
    });
  }

  conditionApply(event) {
    const agree = event.target.checked;
    if(agree)
    {
      this.applyButtonTarget.disabled = false;
    }
    else {
      this.applyButtonTarget.disabled = true;
    }
  }

  validateQuestions() {
    const validations = [];

    document.querySelectorAll("p[data-question-id]").forEach((question) => {
      const questionId = question.dataset.questionId;
      const questionType = question.dataset.questionType;
      let isValid = false;

      if(questionType == 0)
      {
        const answers = document.querySelectorAll(`textarea[data-question-id="${questionId}"]`);
        isValid = [...answers].some(answer => answer.value.length > 0)
      }
      else {
        const answers = document.querySelectorAll(
          `input[data-question-id="${questionId}"]:checked`
        );
  
        isValid = answers.length > 0;
      }
      
      if(isValid == false){
        question.classList.add('text-danger')
      }
      else {
        question.classList.remove('text-danger')
      }

      validations.push({ questionId, isValid });
    });

    const allIsValid = validations.every(validation => validation.isValid === true);

    return allIsValid;
  }


}
