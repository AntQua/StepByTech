import {Controller} from "@hotwired/stimulus";
export default class extends Controller {
    static targets = [];

    connect() {
        this.modal = new bootstrap.Modal(this.element, {
            keyboard: false
        });
        this.modal.show();
    }

    disconnect() {
        this.modal.hide();
    }

    open() {
        if (!this.modal.isOpened) {
            this.modal.show()
        }
    }

    close(event) {
        if (event.detail.success) {
            this.modal.hide();
            window.questionsTabulator.setData(); //TODO: Remover isso depois porque a ideia dessa controller é ser generica
        }
    }

    //TODO: Processar response antes de fechar o modal e mostrar notificações com o modal aberto
    async processResponse(event)
    {
        if (event.detail.fetchResponse.succeeded) {
            event.preventDefault()
            const json = await event.detail.fetchResponse.response.clone().json();
            if(json.status === "success")
            {
                Swal.fire({
                    position: "center",
                    icon: 'success',
                    title: json.message,
                    showConfirmButton: false,
                    timer: 1500
                });
            }
            else {
                Swal.fire({
                    position: "center",
                    icon: 'error',
                    title: json.message,
                    showConfirmButton: false,
                    timer: 1500
                });
            }
        }
    }

    submitEnd() {
        this.modal.hide();
    }

}