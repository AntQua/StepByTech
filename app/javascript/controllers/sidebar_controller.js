import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"];

  connect() {
  }

  toggleSidebar() {
    this.sidebarTarget.classList.toggle('show-sidebar');
  }

  closeSidebar() {
    this.sidebarTarget.classList.remove('show-sidebar');
  }
}
