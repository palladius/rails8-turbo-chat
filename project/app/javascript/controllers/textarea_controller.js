import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="textarea"
export default class extends Controller {
  connect() {
    this.autogrow()
    this.element.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  disconnect() {
    this.element.removeEventListener('keydown', this.handleKeydown.bind(this))
  }

  autogrow() {
    this.element.style.height = 'auto'
    this.element.style.height = this.element.scrollHeight + 'px'
  }

  handleKeydown(event) {
    if (event.key === 'Enter' && !event.shiftKey) { // Use !event.shiftKey for Enter without Shift
      event.preventDefault()
      this.element.form.requestSubmit()
    } else if (event.key === 'Enter' && event.shiftKey) { // Use event.shiftKey for Shift + Enter
      // Allow default behavior (newline)
    }
  }

  // Optional: Add a mutation observer to call autogrow if content changes externally
  // observeMutations() {
  //   const observer = new MutationObserver(() => this.autogrow());
  //   observer.observe(this.element, { attributes: true, childList: true, characterData: true });
  //   this.observer = observer;
  // }

  // disconnect() {
  //   this.element.removeEventListener('keydown', this.handleKeydown.bind(this))
  //   if (this.observer) this.observer.disconnect();
  // }
}