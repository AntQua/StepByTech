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

    submitEnd() {
        this.modal.hide();
    }

}