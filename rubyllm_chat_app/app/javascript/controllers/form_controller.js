import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["input"]

  clear(event) {
    // Optional: Check if event.detail.success is true (Turbo submission succeeded)
    if (event.detail.success) {
      this.element.reset()
      if (this.hasInputTarget) {
        this.inputTarget.focus()
        // Trigger input event to resize textarea back to normal
        this.inputTarget.dispatchEvent(new Event('input', { bubbles: true }))
      }
    }
  }
}
