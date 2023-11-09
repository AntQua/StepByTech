import {Controller} from "@hotwired/stimulus";
import {getMetaValue, loadQuestionsOptions} from "./helper";

export default class extends Controller {
    static targets = ["questionsOptionsTable"];

    async connect() {
        await this.setup();
    }

    async setup() {

        this.programId = this.questionsOptionsTableTarget.dataset.programId;
        let questionsOptions = await loadQuestionsOptions(this.programId);
        questionsOptions = questionsOptions.data.map((question) => {
           return { value: question.id, label: question.title };
        });

        this.questionsOptionsTabulator = new Tabulator(this.questionsOptionsTableTarget, {
            layout: "fitColumns",
            responsiveLayout: true,
            paginationMode: "remote",
            pagination: true, //fit columns to width of table (optional)
            paginationSize: 10,
            groupBy: "step_question_title",
            dataSendParams: {
                page: "start",
                size: "length",
            },
            ajaxURL: this.questionsOptionsTableTarget.dataset.sourceUrl,
            columns: [
                { formatter:"rowSelection", titleFormatter:"rowSelection", width: 50, resizable: false, headerSort: false, cellClick: function(e, cell){ cell.getRow().toggleSelect(); } },
                {
                    title: "Id",
                    field: "id",
                    width: 100,
                },
                { title: "Questão", field: "step_question_title", visible: false },
                {
                    title: "Questão", field: "step_question_id", resizable: false, validator: "required", editor: 'select',
                    editorParams: {
                        values: questionsOptions
                    },
                    formatter: function (cell, formatterParams, onRendered) {
                        if (cell.getValue() > 0) {
                            return questionsOptions.find(obj => obj.value === cell.getValue()).label;
                        }
                        return "";
                    },
                    widthGrow: 3
                },
                {
                    title: "Opção",
                    field: "title",
                    editor: "input",
                    validator: "required",
                    widthGrow: 3
                },
                {
                    title: "Peso",
                    field: "weight",
                    editor: "input",
                    validator: "required",
                }
            ],
        });

        this.programId = this.questionsOptionsTableTarget.dataset.programId;

        this.questionsOptionsTabulator.on("cellEdited", (cell) => {
            const rowValid = cell.getRow().validate();
            if (rowValid === true) {
                const data = cell.getRow().getData();
                this.saveQuestionOption(data);
            }
        });
    }

    saveQuestionOption(data) {
        fetch(this.questionsOptionsTableTarget.dataset.saveQuestionOptionUrl, {
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
                this.questionsOptionsTabulator.setData();
            })
            .catch((error) => {
                console.error("Erro ao processar a solicitação:", error);
            });
    }

    addNewRow() {
        this.questionsOptionsTabulator.addRow({program_id: this.programId}, true);
    }
}
