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
            columns: [
                { formatter:"rowSelection", titleFormatter:"rowSelection", width: 50, resizable: false, headerSort: false, cellClick: function(e, cell){ cell.getRow().toggleSelect(); } },
                {
                    title: "Id",
                    field: "id",
                    width: 100,
                },
                {
                    title: "Questão",
                    field: "title",
                    editor: "input",
                    validator: "required",
                    widthGrow: 3
                },
                {
                    title: "Tipo", field: "question_type", resizable: false, validator: "required", editor: 'select',
                    editorParams: {
                        values: typesEnumOptions
                    },
                    formatter: function (cell, formatterParams, onRendered) {
                        return typesEnumOptions.find(obj => obj.value === cell.getValue()).label;
                    }
                },
                { title: "Step", field: "step_name", visible: false },
                {
                    title: "Step", field: "step_id", resizable: false, editor: 'select',
                    editorParams: {
                        values: stepsOptions
                    },
                    formatter: function (cell, formatterParams, onRendered) {
                        if (cell.getValue() > 0) {
                            return stepsOptions.find(obj => obj.value === cell.getValue()).label;
                        }
                        return "";
                    }
                },
                {
                    title: "Limite",
                    headerTooltip: "Se o tipo for Texto Livre esse campo será um limite de caracteres caso contrário vai ser limite de respostas",
                    field: "limit",
                    editor: "input",
                    validator: "required",
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
}
