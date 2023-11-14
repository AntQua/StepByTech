import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modalBody"]

  static values = {
    contentUrl: String,
    contentType: String
  }

  show() {
    // For debugging purposes, set these directly.
    this.contentUrlValue = 'path_to_some_image.jpg';
    this.contentTypeValue = 'image';
    console.log('Content type value:', this.contentTypeValue);
    console.log('Content URL value:', this.contentUrlValue);
    console.log(this.modalBodyTarget);

    if (this.contentTypeValue === 'image') {
      this.modalBodyTarget.innerHTML = `<img src="${this.contentUrlValue}" class="img-fluid">`
    } else if (this.contentTypeValue === 'video') {
      this.modalBodyTarget.innerHTML = `<video width="100%" height="auto" controls>
                                          <source src="${this.contentUrlValue}" type="video/mp4">
                                          Your browser does not support the video tag.
                                        </video>`
    }

    // Initialize and show the Bootstrap modal
    var myModal = new bootstrap.Modal(document.getElementById('mediaModal'), {
      keyboard: true // Allows closing with the escape key
    });
    myModal.show();
  }
}
