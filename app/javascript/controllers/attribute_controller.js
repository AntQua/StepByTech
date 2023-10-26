import { Controller } from "@hotwired/stimulus";
import { getMetaValue } from "./helper";

// Connects to data-controller="attribute"
export default class extends Controller {
  static targets = ["attributeTable"];

  connect() {
    this.setup();
  }

  setup() {
    this.attributesTabulator = new Tabulator(this.attributeTableTarget, {
      layout: "fitDataFill",
      paginationMode: "remote",
      pagination: true, //fit columns to width of table (optional)
      paginationSize: 10,
      dataSendParams: {
        page: "start",
        size: "length",
      },
      ajaxURL: this.attributeTableTarget.dataset.sourceUrl,
      // initialSort:[
      //   {column:"id", dir:"desc"},
      // ],
      columns: [
        {
          title:"Id",
          field: "id",
        },
        {
          title: "Nome da Opção",
          field: "name",
          editor: "input",
          validator: "required",
        },
        {
          title: "Questão",
          field: "question",
          editor: "list",
          editorParams: {
            autocomplete: "true",
            allowEmpty: true,
            listOnEmpty: true,
            freetext: true,
            valuesLookup: true,
          },
          validator: "required",
        },
        {
          title: "Peso",
          field: "weight",
          editor: "list",
          editorParams: {
            values: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
          },
          validator: "required",
        },
      ],
    });

    this.programId = this.attributeTableTarget.dataset.programId;

    this.attributesTabulator.on("cellEdited", (cell) => {
      const rowValid = cell.getRow().validate();
      if (rowValid == true) {
        const data = cell.getRow().getData();
        this.saveAttribute(data);
      }
    });
  }

  saveAttribute(data) {
    fetch(`/program_attributes/save`, {
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
        this.attributesTabulator.setData();
      })
      .catch((error) => {
        console.error("Erro ao processar a solicitação:", error);
      });
  }

  addNewRow() {
    this.attributesTabulator.addRow({ program_id: this.programId }, true);
  }
}
