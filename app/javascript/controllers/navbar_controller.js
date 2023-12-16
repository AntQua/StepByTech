import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.highlightActiveLink();
    window.addEventListener('hashchange', () => this.highlightActiveLink());
    window.addEventListener('turbo:load', () => this.highlightActiveLink());
  }

  highlightActiveLink() {
    setTimeout(() => {
      const currentPath = window.location.pathname;
      const currentHash = window.location.hash;

      this.linkTargets.forEach((link) => {
        const linkHref = new URL(link.href, window.location.origin);
        const isPathMatch = linkHref.pathname === currentPath && linkHref.hash === "";
        const isHashMatch = currentHash && linkHref.hash === currentHash;

        // Modify the condition for highlighting the Home link
        const isHomeLink = currentPath === '/' && !currentHash && linkHref.hash === '#home';

        link.classList.toggle('active', isPathMatch || isHashMatch || isHomeLink);
      });
    }, 100);
  }
}

