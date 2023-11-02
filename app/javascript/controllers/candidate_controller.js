import { Controller } from "@hotwired/stimulus";
import { getMetaValue } from "./helper";

export default class extends Controller {
  static targets = ["candidateTable"];

  async connect() {
    await this.setup();

  }

  loadStepsOptions(programId) {
    return fetch(this.candidateTableTarget.dataset.stepsUrl)
        .then(response => {
          if(!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();
        })
        .catch(error => console.error('Error: ', error));
  }

  async setup() {

    this.programId = this.candidateTableTarget.dataset.programId;
    const steps = await this.loadStepsOptions(this.programId);

    this.candidateTabulator = new Tabulator(this.candidateTableTarget, {
      layout: "fitColumns",
      resizableColumnFit:true,
      responsiveLayout:true,
      paginationMode: "remote",
      pagination: true, //fit columns to width of table (optional)
      paginationSize: 10,
      dataSendParams: {
        page: "start",
        size: "length",
      },
      ajaxURL: this.candidateTableTarget.dataset.sourceUrl,
      // initialSort:[
      //   {column:"id", dir:"desc"},
      // ],
      selectableCheck:function(row){
        console.log(row)
        return row.getData().id > 1; //allow selection of rows where the age is greater than 18
      },
      columns: [
        { formatter:"rowSelection", titleFormatter:"rowSelection", width: 50, resizable: false, headerSort: false, cellClick: function(e, cell){ cell.getRow().toggleSelect(); } },
        { title: "Id", field: "id", visible: false },
        { title: "Usuário", field: "user_name", widthGrow: 2, resizable: false },
        { title: "Genero", field: "user_gender" },
        { title: "Step", field: "step_id", resizable: false, editor: 'select',
          editorParams: {
            values: steps
          },
          formatter: function(cell, formatterParams, onRendered) {
            if (cell.getValue() > 0) {
              return steps.find(obj => obj.value === cell.getValue()).label;
            }
            return "";
          }
        },
        { title: "Data do Registro", field: "registration_date", resizable: false },
        { title: "Status", field: "status", resizable: false },
        { title: "Total", field: "total_points", resizable: false },
      ],
    });

    // this.programId = this.candidateTableTarget.dataset.programId;

    this.candidateTabulator.on("cellEdited", (cell) => {
      const rowValid = cell.getRow().validate();
      if (rowValid === true) {
        const data = cell.getRow().getData();
        this.saveCandidate(data);
      }
    });
  }

  saveCandidate(data) {
    fetch(this.candidateTableTarget.dataset.updateStepUrl, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": getMetaValue("csrf-token"),
      },
      body: JSON.stringify(data),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Network response was not ok: ${response.status}`);
        }
        return response.json();
      })
      .then((newData) => {
        this.candidateTabulator.setData();
      })
      .catch((error) => {
        console.error("Network response was not ok:", error);
      });
  }

  // addNewRow() {
  //   this.attributesTabulator.addRow({ program_id: this.programId }, true);
  // }
}