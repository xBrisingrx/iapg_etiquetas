import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"
// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    let backdrop = document.querySelector(".modal-backdrop");
    if (backdrop) {
      backdrop.remove();
    }
    this.modal = new Modal(this.element);
    this.modal.show();
    this.element.addEventListener('hidden.bs.modal', (event) => {
      this.element.remove();
    })
  }

  close(){
    this.modal.hide()
    document.querySelector(".modal-backdrop").remove()
  }

  submitEnd(e) {    
    if (e.detail.success) {
      this.close()
    }
  }

}
