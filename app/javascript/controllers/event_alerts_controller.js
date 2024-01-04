import { Controller } from "@hotwired/stimulus";
import Swal from 'sweetalert2';

export default class extends Controller {
  static targets = ["form"];
  boundSubmit; // Declare boundSubmit
  submissionInProgress = false; // Flag to track submission status

  connect() {
    this.initializeForm();
  }

  submit(event) {
    event.preventDefault();
    if (this.submissionInProgress) return; // Prevent duplicate submissions

    this.submissionInProgress = true; // Set flag to true
    const form = this.formTarget;
    const eventId = form.dataset.eventId;
    const url = form.action;
    const actionType = form.dataset.actionType;

    form.querySelector('button[type="submit"]').disabled = true; // Disable the submit button

    fetch(url, {
      method: form.method,
      body: new FormData(form),
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'text/javascript'
      }
    })
      .then(response => response.text())
      .then(() => {
        let title = actionType === 'register' ? 'Parabéns' : 'Cancelado';
        let text = actionType === 'register' ? 'Você ingressou no evento com sucesso! Verifique o seu email.' : 'Você cancelou a inscrição no evento com sucesso! Verifique o seu email.';

        Swal.fire({
          title: title,
          text: text,
          icon: 'success',
          confirmButtonText: 'Ok'
        }).then((result) => {
          if (result.isConfirmed) {
            this.updateRegistrationStatus(eventId, actionType === 'register');
          }
        });
      })
      .finally(() => {
        this.submissionInProgress = false; // Reset flag after submission
      });
  }

  updateRegistrationStatus(eventId, isRegistered) {
    const registrationStatusDiv = document.getElementById('registration-status');
    if (isRegistered) {
      registrationStatusDiv.innerHTML =
        `<p>Já se encontra inscrito neste evento!</p>` +
        `<form action="/events/${eventId}/unregister" method="delete" data-action="submit->event-alerts#submit" data-event-alerts-target="form" data-action-type="unregister" class="event-alerts-form">` +
        `<button type='submit' class="btn-edit-profile text-decoration-none">Remover inscrição no evento</button>` +
        `</form>`;
    } else {
      registrationStatusDiv.innerHTML =
        `<form action="/events/${eventId}/participate" method="post" data-action="submit->event-alerts#submit" data-event-alerts-target="form" data-action-type="register" class="event-alerts">` +
        `<button type='submit' class="btn-edit-profile text-decoration-none">Participar neste evento</button>` +
        `</form>`;
    }
    this.initializeForm();
  }

  initializeForm() {
    const form = this.element.querySelector('[data-event-alerts-target="form"]');
    if (form && !this.boundSubmit) {
      this.boundSubmit = (event) => this.submit(event);
      form.addEventListener('submit', this.boundSubmit);
    }
  }
}
