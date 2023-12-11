import {Controller} from "@hotwired/stimulus";
import {getMetaValue, loadStepsOptions} from "./helper";

export default class QuestionController extends Controller {
    static targets = ["questionsTable"];

    async connect() {
        await this.setup();
    }

    get questionController() {
        return this.application.getControllerForElementAndIdentifier(this.element, "questionTable");
    }

    async setup() {

        this.programId = this.questionsTableTarget.dataset.programId;
        const typesEnumOptions = [{value: 0, label: "Texto Livre"}, {value: 1, label: "Multipla Escolha"}];
        const stepsOptions = await loadStepsOptions(this.programId);

        window.questionsTabulator = this.questionsTabulator = new Tabulator(this.questionsTableTarget, {
            layout: "fitColumns",
            responsiveLayout: true,
            paginationMode: "remote",
            pagination: true, //fit columns to width of table (optional)
            paginationSize: 10,
            groupBy: "step_name",
            dataSendParams: {
                page: "start",
                size: "length",
            },
            ajaxURL: this.questionsTableTarget.dataset.sourceUrl,
            groupHeader:function(value, count, data, group){
                //value - the value all members of this group share
                //count - the number of rows in this group
                //data - an array of all the row data objects in this group
                //group - the group component for the group
                const stepId = data[0].step_id;
                const content = document.createElement('div');
                content.classList.add('btn-header-preview');
            
                const infoSpan = document.createElement('span');
                infoSpan.textContent = `${value} (${count} item(s))`;
                content.appendChild(infoSpan);
            
                const previewButton = document.createElement('a');
                previewButton.textContent = "Preview";
                previewButton.classList.add('btn-preview');
                previewButton.setAttribute("target", "_blank");
                previewButton.setAttribute("href", `/step_questions/${stepId}/preview`);

                content.appendChild(previewButton);
            
                return content;
            },
            columns: [
                { formatter:"rowSelection", titleFormatter:"rowSelection", width: 50, resizable: false, headerSort: false, cellClick: function(e, cell){ cell.getRow().toggleSelect(); } },
                {
                    title: "Id",
                    field: "id",
                    width: 100,
                    visible: false
                },
                {
                    field: "program_id",
                    visible: false
                },
                {
                    title: "Questão",
                    field: "title",
                    // editor: "input",
                    validator: "required",
                    widthGrow: 3
                },
                {
                    title: "Tipo", field: "question_type", resizable: false, validator: "required",
                },
                { title: "Step", field: "step_name", visible: false },
                {
                    title: "Limite",
                    headerTooltip: "Se o tipo for Texto Livre esse campo será um limite de caracteres caso contrário vai ser limite de respostas",
                    field: "limit",
                    // editor: "input",
                    validator: "required",
                },
                {
                    title:"Ações",
                    formatter: (cell, formatterParams, onRendered) => {
                        const data = cell.getData();
                        const editIcon = document.getElementById('editIcon').content.cloneNode(true);
                        const editButton = document.createElement('a');
                        editButton.classList.add('btn');
                        editButton.classList.add('btn-secondary');
                        editButton.classList.add('mx-1');
                        editButton.setAttribute('data-controller', 'question-modal');
                        editButton.setAttribute('data-action', 'click->question-modal#showEditModal');
                        editButton.href = `/step_questions/${data.program_id}/edit/${data.id}`;

                        editButton.appendChild(editIcon);

                        const deleteIcon = document.getElementById('deleteIcon').content.cloneNode(true);
                        const deleteButton = document.createElement('a');
                        deleteButton.classList.add('btn');
                        deleteButton.classList.add('btn-danger');
                        deleteButton.setAttribute('data-step-question-id', data.id);
                        deleteButton.setAttribute('data-controller', 'question-modal');
                        deleteButton.setAttribute('data-target-table', '');
                        deleteButton.setAttribute('data-action', 'click->question-modal#showAlertDeleteConfirmation');
                        deleteButton.appendChild(deleteIcon);

                        const div = document.createElement('div');
                        div.appendChild(editButton);
                        div.appendChild(deleteButton);

                        return div;
                    }
                }
            ],
        });

        this.programId = this.questionsTableTarget.dataset.programId;

        this.questionsTabulator.on("cellEdited", (cell) => {
            const rowValid = cell.getRow().validate();
            if (rowValid === true) {
                const data = cell.getRow().getData();
                this.saveQuestion(data);
            }
        });
    }

    saveQuestion(data) {
        fetch(this.questionsTableTarget.dataset.saveQuestionUrl, {
            method: "PATCH",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": getMetaValue("csrf-token"),
            },
            body: JSON.stringify(data),
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error(`Erro na solicitação: ${response.status}`);
                }
                return response.json();
            })
            .then((newData) => {
                //para atualizar a tabela com os dados
                this.questionsTabulator.setData();
            })
            .catch((error) => {
                console.error("Erro ao processar a solicitação:", error);
            });
    }

    addNewRow() {
        this.questionsTabulator.addRow({program_id: this.programId}, true);
    }

    clone(event) {

        Swal.fire({
            title: "Clonar Questionário",
            html: ``,
            showCancelButton: true,
            cancelButtonText: "Cancelar",
            confirmButtonText: "Confirmar",
            showLoaderOnConfirm: true,
            confirmButtonColor: "#B973FF",
            allowOutsideClick: () => !Swal.isLoading(),
            preConfirm: () => {
                const modalContent = document.querySelector('#swal2-html-container');
                const selectedProgram = modalContent.querySelector('#select-program').value;
                const selectedStepOrigin = modalContent.querySelector('#select-step-origin').value;
                const selectedStepDest = modalContent.querySelector('#select-step-dest').value;

                if (selectedProgram && selectedStepOrigin && selectedStepDest)
                {
                    fetch(`/step_questions/${this.programId}/clone`, {
                        method: 'POST',
                        body: JSON.stringify({ step_origin_id: selectedStepOrigin, step_dest_id: selectedStepDest }),
                        headers: {
                            'Content-Type': 'application/json',
                            'Accept': "application/json",
                            'X-CSRF-Token': getMetaValue("csrf-token")
                        }
                    }).then((response) => {
                        if (!response.ok) {
                            throw new Error(`Erro na solicitação: ${response.status}`);
                        }
                        return response.json();
                    }).then((result) => {
                        Swal.fire({
                            position: "center",
                            icon: 'success',
                            title: result.message,
                            showConfirmButton: false,
                            timer: 1500
                        });

                        this.questionsTabulator.setData();
                    });
                }
                else {
                    Swal.showValidationMessage(`É necessário preencher todos os campos!`);
                }
            },
            willOpen: async (html) => {
                Swal.showLoading();
                fetch(`/step_questions/${this.programId}/clone`, {
                    method: 'GET',
                    headers: {
                        Accept: "text/html"
                    }
                }).then((result) => {
                    return result.text();
                }).then((result) => {
                    html.querySelector('#swal2-html-container').innerHTML = result;
                    Swal.hideLoading();
                });
            }

        });
    }

    cloneSelectProgram(event) {
        const modalContent = event.target.closest('#clone-modal-content');
        const selectStepOrigin = modalContent.querySelector('#select-step-origin');

        const programId = event.target.value;

        if(programId)
        {
            Swal.showLoading();
            fetch(`/steps/${programId}/get_steps_with_questionnaire`, {
                method: "GET",
                headers: {
                    Accept: "application/json"
                }
            }).then((response) => {
                return response.json();
            }).then((result) => {
                selectStepOrigin.innerHTML = '';
                for (let i = 0; i < result.length; i++) {
                    const step = result[i];
                    const option = document.createElement('option');
                    option.value = step.value;
                    option.innerText = step.text;

                    selectStepOrigin.appendChild(option);
                }
                Swal.hideLoading();
            });
        }
        else {
            selectStepOrigin.innerHTML = '';
        }

    }
}
