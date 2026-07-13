import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="textarea"
export default class extends Controller {
  connect() {
    this.autogrow()
  }

  disconnect() {
  }

  autogrow() {
    this.element.style.height = 'auto'
    this.element.style.height = this.element.scrollHeight + 'px'
  }

  handleKeydown(event) {
    console.log("Keydown event triggered: ", event.key, "Shift:", event.shiftKey)
    if (event.key === 'Enter' && !event.shiftKey) { // Use !event.shiftKey for Enter without Shift
      event.preventDefault()
      const submitButton = this.element.form.querySelector('input[type="submit"], button[type="submit"]')
      if (submitButton) {
        submitButton.click()
      } else {
        this.element.form.requestSubmit()
      }
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