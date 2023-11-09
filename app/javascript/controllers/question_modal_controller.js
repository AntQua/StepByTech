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
}