import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-sidebar"
export default class extends Controller {
  static targets = [ "sidebar" ]

  toggle() {
    this.element.classList.toggle('sidebar-open');
  }
}