import { Controller } from "@hotwired/stimulus";
import { getMetaValue } from "./helper";

export default class extends Controller {
  static targets = ["candidateTable"];

  connect() {
    this.setup();
  }

  setup() {
    this.candidateTabulator = new Tabulator(this.candidateTableTarget, {
      layout: "fitColumns",
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
      columns: [
        {
          title: "Id do Usuário",
          field: "user_id",
          width: 150,
        },
        {
          title: "Usuário",
          field: "user_name",
          validator: "required",
        },
        {
          title: "Step",
          field: "step_name",
        },
        {
          title: "Data do Registro",
          field: "registration_date"
        },
        {
          title: "Total",
          field: "total_points",
        },
      ],
    });

    // this.programId = this.candidateTableTarget.dataset.programId;

    // this.attributesTabulator.on("cellEdited", (cell) => {
    //   const rowValid = cell.getRow().validate();
    //   if (rowValid == true) {
    //     const data = cell.getRow().getData();
    //     this.saveAttribute(data);
    //   }
    // });
  }

  // saveAttribute(data) {
  //   fetch(`/program_attributes/save`, {
  //     method: "PATCH",
  //     headers: {
  //       "Content-Type": "application/json",
  //       "X-CSRF-Token": getMetaValue("csrf-token"),
  //     },
  //     body: JSON.stringify(data),
  //   })
  //     .then((response) => {
  //       if (!response.ok) {
  //         throw new Error(`Erro na solicitação: ${response.status}`);
  //       }
  //       return response.json();
  //     })
  //     .then((newData) => {
  //       //para atualizar a tabela com os dados
  //       this.attributesTabulator.setData();
  //     })
  //     .catch((error) => {
  //       console.error("Erro ao processar a solicitação:", error);
  //     });
  // }

  // addNewRow() {
  //   this.attributesTabulator.addRow({ program_id: this.programId }, true);
  // }
}
