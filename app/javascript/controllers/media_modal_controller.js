import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modalBody"]

  show(event) {
    event.preventDefault(); // Prevent the link from navigating away.
    const contentUrl = event.currentTarget.getAttribute('data-media-modal-content-url');
    const contentType = event.currentTarget.getAttribute('data-media-modal-content-type');

    if (contentType === 'image') {
      this.modalBodyTarget.innerHTML = `<img src="${contentUrl}" class="img-fluid">`
    } else if (contentType === 'video') {
      this.modalBodyTarget.innerHTML = `<video width="100%" height="auto" controls>
                                          <source src="${contentUrl}" type="video/mp4">
                                          Your browser does not support the video tag.
                                        </video>`
    }

    // Initialize and show the Bootstrap modal
    let myModal = new bootstrap.Modal(document.getElementById('mediaModal'), {
      keyboard: true // Allows closing with the escape key
    });
    myModal.show();
  }
}
