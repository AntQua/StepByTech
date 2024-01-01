import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show(event) {
    event.preventDefault();
    const contentUrl = event.currentTarget.getAttribute('data-media-modal-content-url');
    const contentType = event.currentTarget.getAttribute('data-media-modal-content-type');
    const modalId = event.currentTarget.getAttribute('data-media-modal-target');

    // Find the modal body within the specific modal
    const modal = document.getElementById(modalId);
    const modalBody = modal.querySelector('.modal-body');

    if (contentType === 'image') {
      modalBody.innerHTML = `<img src="${contentUrl}" class="img-fluid">`;
    } else if (contentType === 'video') {
      modalBody.innerHTML = `<video width="100%" height="auto" controls>
                              <source src="${contentUrl}" type="video/mp4">
                              Your browser does not support the video tag.
                            </video>`;
    }

    let myModal = new bootstrap.Modal(modal, {
      keyboard: true
    });
    myModal.show();
  }
}

