import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.autogrow()
  }

  autogrow() {
    this.element.style.height = 'auto'
    this.element.style.height = this.element.scrollHeight + 'px'
  }

  handleKeydown(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault()
      this.element.form.requestSubmit()
    }
  }

  resetForm() {
    this.element.value = ''
    this.autogrow()
    this.element.focus()
  }
}
