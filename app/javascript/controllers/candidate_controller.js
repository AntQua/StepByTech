import {Controller} from "@hotwired/stimulus";
import {getMetaValue} from "./helper";

export default class extends Controller {
    static targets = ["candidateTable"];

    async connect() {
        await this.setup();
    }

    loadStepsOptions(programId) {
        return fetch(this.candidateTableTarget.dataset.stepsUrl)
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                return response.json();
            })
            .catch((error) => console.error("Error: ", error));
    }

    async setup() {
        if (!this.hasCandidateTableTarget)
            return;

        this.programId = this.candidateTableTarget.dataset.programId;
        const steps = await this.loadStepsOptions(this.programId);

        window.candidateTabulator = this.candidateTabulator = new Tabulator(
            this.candidateTableTarget,
            {
                layout: "fitColumns",
                resizableColumnFit: true,
                responsiveLayout: true,
                paginationMode: "remote",
                pagination: true, //fit columns to width of table (optional)
                paginationSize: 10,
                groupBy: "user_gender",
                dataSendParams: {
                    page: "start",
                    size: "length",
                },
                ajaxURL: this.candidateTableTarget.dataset.sourceUrl,
                selectableCheck: function (row) {
                    return row.getData().id > 1;
                },
                columns: [
                    {
                        formatter: "rowSelection",
                        titleFormatter: "rowSelection",
                        width: 50,
                        resizable: false,
                        headerSort: false,
                        cellClick: function (e, cell) {
                            cell.getRow().toggleSelect();
                        },
                    },
                    {title: "Id", field: "id", visible: false},
                    {
                        title: "Usuário",
                        field: "user_name",
                        widthGrow: 2,
                        width: 200,
                        resizable: false,
                    },
                    {title: "Genero", field: "user_gender", visible: false},
                    {
                        title: "Candidatura",
                        field: "registration_date",
                        resizable: false,
                    },
                    {title: "Step", field: "current_step_name"},
                    {field: "next_step_name", visible: false},
                    {title: "Status", field: "status_description", resizable: false},
                    {title: "Total", field: "total_points", resizable: false},
                    {field: "evaluated_value", visible: false },
                    {
                        title: "Avaliado",
                        field: "evaluated",
                        resizable: false,
                    },
                    {field: "status_value", visible: false},
                    {
                        title: "Ações",
                        download: false,
                        formatter: (cell, formatterParams, onRendered) => {
                            const data = cell.getData();
                            const div = document.createElement("div");
                            // show profile candidate
                            const showProfileButton = document.createElement("a");
                            const showProfileIcon = document
                                .getElementById("showProfileIcon")
                                .content.cloneNode(true);
                            showProfileButton.classList.add("btn");
                            showProfileButton.classList.add("btn-secondary");
                            showProfileButton.classList.add("mx-1");
                            showProfileButton.setAttribute("target", "_blank");
                            showProfileButton.href = `/users_programs_steps/candidate/${data.id}`;
                            showProfileButton.appendChild(showProfileIcon);
                            div.appendChild(showProfileButton);

                            if (data.status_value === 0 && data.evaluated_value === true) {
                                //Somente mostra quando o status for Aguardando aprovação
                                const approveIcon = document
                                    .getElementById("approveIcon")
                                    .content.cloneNode(true);
                                const approveButton = document.createElement("button");
                                approveButton.type = "button";
                                approveButton.classList.add("btn");
                                approveButton.classList.add("btn-success");
                                approveButton.classList.add("mx-1");
                                approveButton.setAttribute(
                                    "data-user_program_step_id",
                                    data.id
                                );
                                approveButton.setAttribute(
                                    "data-current_step_name",
                                    data.current_step_name
                                );
                                approveButton.setAttribute(
                                    "data-next_step_name",
                                    data.next_step_name
                                );
                                approveButton.addEventListener(
                                    "click",
                                    this.showApproveConfirmation
                                );
                                approveButton.appendChild(approveIcon);
                                div.appendChild(approveButton);

                                const disapproveIcon = document
                                    .getElementById("disapproveIcon")
                                    .content.cloneNode(true);
                                const disapproveButton = document.createElement("button");
                                disapproveButton.type = "button";
                                disapproveButton.classList.add("btn");
                                disapproveButton.classList.add("btn-danger");
                                disapproveButton.setAttribute(
                                    "data-user_program_step_id",
                                    data.id
                                );
                                disapproveButton.addEventListener(
                                    "click",
                                    this.showDisaproveConfirmation
                                );
                                disapproveButton.appendChild(disapproveIcon);
                                div.appendChild(disapproveButton);
                            }

                            return div;
                        },
                    },
                ],
            }
        );

        // this.programId = this.candidateTableTarget.dataset.programId;

        this.candidateTabulator.on("cellEdited", (cell) => {
            const rowValid = cell.getRow().validate();
            if (rowValid === true) {
                const data = cell.getRow().getData();
                this.saveCandidate(data);
            }
        });

        const searchInput = document.getElementById("searchInput");
        searchInput.addEventListener("input", (event) =>
            this.searchCandidates(event)
        );
    }

    showApproveConfirmation(event) {
        const current_step_name = event.currentTarget.dataset.current_step_name;
        const next_step_name = event.currentTarget.dataset.next_step_name;
        const user_program_step_id =
            event.currentTarget.dataset.user_program_step_id;

        Swal.fire({
            title: "Você tem certeza?",
            text: `${current_step_name} -> ${next_step_name}`,
            icon: "warning",
            showCancelButton: true,
            cancelButtonText: "Cancelar",
            confirmButtonColor: "#B973FF",
            // cancelButtonColor: "#d33",
            confirmButtonText: "Sim, quero aprovar!",
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`/users_programs_steps/approve/${user_program_step_id}`, {
                    method: "PATCH",
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-Token": getMetaValue("csrf-token"),
                    },
                })
                    .then((response) => {
                        if (!response.ok) {
                            throw new Error(`Erro na solicitação: ${response.status}`);
                        }
                        return response.json();
                    })
                    .then((response) => {
                        Swal.fire({
                            position: "center",
                            icon: "success",
                            title: response.message,
                            showConfirmButton: false,
                            timer: 1500,
                        });

                        window.candidateTabulator.setData();
                    })
                    .catch((error) => {
                        console.error("Erro ao processar a solicitação:", error);
                    });
            }
        });
    }

    showDisaproveConfirmation(event) {
        const user_program_step_id =
            event.currentTarget.dataset.user_program_step_id;

        Swal.fire({
            title: "Você tem certeza?",
            text: "Não é possivel reverter!",
            icon: "warning",
            showCancelButton: true,
            cancelButtonText: "Cancelar",
            confirmButtonColor: "#B973FF",
            // cancelButtonColor: "#d33",
            confirmButtonText: "Sim, quero reprovar!",
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`/users_programs_steps/disapprove/${user_program_step_id}`, {
                    method: "PATCH",
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-Token": getMetaValue("csrf-token"),
                    },
                })
                    .then((response) => {
                        if (!response.ok) {
                            throw new Error(`Erro na solicitação: ${response.status}`);
                        }
                        return response.json();
                    })
                    .then((response) => {
                        Swal.fire({
                            position: "center",
                            icon: "success",
                            title: response.message,
                            showConfirmButton: false,
                            timer: 1500,
                        });

                        window.candidateTabulator.setData();
                    })
                    .catch((error) => {
                        console.error("Erro ao processar a solicitação:", error);
                    });
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

    downloadXlsx(event) {
        candidateTabulator.download("xlsx", "candidatos.xlsx", {
            sheetName: "Candidatos",
        });
    }

    downloadPdf(event) {
        candidateTabulator.download("pdf", "candidatos.pdf", {
            orientation: "portrait", //set page orientation to portrait
            title: "Candidatos", //add title to report
        });
    }

    refreshTable(event) {
        window.candidateTabulator.setData();
    }

    searchCandidates(event) {
        const searchTerm = event.target.value.trim().toLowerCase();
        this.candidateTabulator.setFilter("user_name", "like", searchTerm);
    }

    finishEvaluation(event) {
        const button = event.currentTarget;
        const userProgramStepId = button.dataset.id;
        console.log("CLICOU PARA FINALIZAR AVALIAÇÃO");

        Swal.fire({
            title: "Finalizar Avaliação?",
            text: "Você tem certeza que deseja finalizar a avaliação?",
            icon: "question",
            showCancelButton: true,
            confirmButtonColor: "#B973FF",
            cancelButtonColor: "#d33",
            confirmButtonText: "Sim, finalizar!",
            cancelButtonText: "Cancelar",
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`/update_evaluation_status/${userProgramStepId}`, {
                    method: "PATCH",
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-Token": getMetaValue("csrf-token"),
                    },
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
                    }).then(() => {
                        window.location.reload();
                    })
                }).catch((error) => {
                    console.error("Erro ao finalizar avaliação:", error);
                });
            }
        });
    }

    evaluateResponse(event) {
        const button = event.target;
        const assignedCustomWeight = button.dataset.customWeight === "true";
        const stepId = parseInt(button.dataset.stepId);

        Swal.fire({
            title: "Qual a nota?",
            input: "number",
            inputAttributes: {
                max: 100,
                min: 0,
            },
            inputValidator: (value) => {
                const weight = parseInt(value);

                if (isNaN(weight)) {
                    return "Atribua uma nota de 0 a 100";
                }

                if (weight > 100) {
                    return "Nota máxima é 100";
                }
                if (weight < 0) {
                    return "Nota minima é 0";
                }
            },
            showDenyButton: assignedCustomWeight,
            showCancelButton: true,
            cancelButtonText: "Cancelar",
            confirmButtonText: "Confirmar",
            denyButtonText: "Restaurar padrão",
            showLoaderOnConfirm: true,
            confirmButtonColor: "#B973FF",
            allowOutsideClick: () => !Swal.isLoading(),
        }).then((result) => {
            const answerId = button.dataset.answerId;
            if ((result.isConfirmed || result.isDenied) && answerId) {
                const data = JSON.stringify({
                    custom_weight: parseInt(result.value),
                    restore_weight_default: result.isDenied,
                });
                fetch(`/users_programs_steps/custom_weight/${answerId}`, {
                    method: "PATCH",
                    body: data,
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-Token": getMetaValue("csrf-token"),
                    },
                })
                    .then((response) => {
                        if (!response.ok) {
                            throw new Error(`Erro na solicitação: ${response.status}`);
                        }
                        return response.json();
                    })
                    .then((response) => {
                        if (response.data) {
                            const {total, weight, has_custom_weight} = response.data;
                            // Update total
                            document.getElementById(`step_${stepId}_total`).innerText = total;

                            // Update weight button
                            button.classList.toggle("btn-danger", weight === 0);
                            button.classList.toggle("btn-primary", weight !== 0);
                            button.innerText = `${weight} (${
                                has_custom_weight === true ? "Atribuida" : "Padrão"
                            })`;
                            button.dataset.customWeight = has_custom_weight;
                        }

                        Swal.fire({
                            position: "center",
                            icon: "success",
                            title: response.message,
                            showConfirmButton: false,
                            timer: 1500,
                        });
                    })
                    .catch((error) => {
                        console.error("Erro ao processar a solicitação:", error);
                    });
            }
        });
    }
}
