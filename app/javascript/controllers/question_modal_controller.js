import {Controller} from "@hotwired/stimulus";
import {getMetaValue, loadStepsOptions} from "./helper";

export default class extends Controller {
    static targets = [];

    showNewModal(event) {
        event.preventDefault();
        this.url = this.element.getAttribute("href");
        fetch(this.url, {
            headers: {
                Accept: "text/vnd.turbo_stream.html"
            }
        })
            .then(response => response.text())
            .then(html => Turbo.renderStreamMessage(html));
    }

    showEditModal(event) {
        event.preventDefault();
        this.url = this.element.getAttribute("href");
        fetch(this.url, {
            headers: {
                Accept: "text/vnd.turbo_stream.html"
            }
        })
            .then(response => response.text())
            .then(html => Turbo.renderStreamMessage(html));
    }

    showAlertDeleteConfirmation(event)
    {
        event.preventDefault();

        const stepQuestionId = event.currentTarget.dataset.stepQuestionId;

        Swal.fire({
            title: "Você tem certeza?",
            text: "Não é possivel reverter!",
            icon: "warning",
            showCancelButton: true,
            cancelButtonText: "Cancelar",
            confirmButtonColor: "#B973FF",
            // cancelButtonColor: "#d33",
            confirmButtonText: "Sim, delete isto!"
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`/step_questions/${stepQuestionId}`, {
                    method: "DELETE",
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-Token": getMetaValue("csrf-token"),
                    }
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
                            icon: 'success',
                            title: response.message,
                            showConfirmButton: false,
                            timer: 1500
                        });

                        window.questionsTabulator.setData();
                    })
                    .catch((error) => {
                        console.error("Erro ao processar a solicitação:", error);
                    });

            }
        });
    }
}