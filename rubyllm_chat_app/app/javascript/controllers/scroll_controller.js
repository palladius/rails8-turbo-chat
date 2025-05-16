import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll"
export default class extends Controller {
  connect() {
    this.scrollToBottom()
    this.observer = new MutationObserver(this.handleMutations.bind(this))
    this.observer.observe(this.element, { childList: true })
  }

  disconnect() {
    this.observer.disconnect()
  }

  handleMutations(mutations) {
    // Check if new nodes were added
    if (mutations.some(mutation => mutation.addedNodes.length > 0)) {
      this.scrollToBottom()
    }
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }
}