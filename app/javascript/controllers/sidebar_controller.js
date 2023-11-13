import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["sidebar"];

  connect() {
  }

  toggleSidebar() {
    console.log("Toggle sidebar works !!!");
    this.sidebarTarget.classList.toggle('show-sidebar');
  }
}
