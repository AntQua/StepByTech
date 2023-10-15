import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Programs controller connected.");

    this.listenForForm();
  }

  listenForForm() {
    this.element.addEventListener("ajax:success", (event) => {
      console.log("AJAX request made.");

      const [data, , xhr] = event.detail;
      if(xhr.responseURL.includes("/programs")) {
        document.querySelector("main").innerHTML = data;
      }
    });
  }
}
