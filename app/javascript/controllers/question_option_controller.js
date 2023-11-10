import {Controller} from "@hotwired/stimulus";
import {getMetaValue, loadQuestionsOptions} from "./helper";

export default class extends Controller {
    static targets = ["optionTitle", "optionWeight", "optionsTableBody", "optionRowTemplate"]

    async connect() {
    }
    removeOption(event) {
        event.target.closest("tr").remove();
    }
    addNewOptionModal(event) {
        event.preventDefault();
        const title = this.optionTitleTarget.value;
        const weight = this.optionWeightTarget.value;

        if(title && weight)
        {
            const clone = this.optionRowTemplateTarget.content.cloneNode(true);
            let tds = clone.querySelectorAll("td");
            tds[0].querySelector("input").value = title;
            tds[0].innerHTML += title;
            tds[1].querySelector("input").value = weight;
            tds[1].innerHTML += weight;
            tds[2].querySelector("button.remove-option").addEventListener("click", this.removeOption);
            this.optionsTableBodyTarget.appendChild(clone);
            this.optionTitleTarget.value = "";
            this.optionWeightTarget.value = "";
        }
    }
}
