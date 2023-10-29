import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list"]; // We will use this target to refer to our list of registered users

  //  connect() {
  //   console.log("toggle_registered_users_controller connected!");
  // }

  toggle() {
    // This will toggle the display of the list
    this.listTarget.classList.toggle('hidden');
  }
}
