// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as Turbo from "@hotwired/turbo-rails"
import "controllers"

Turbo.StreamActions.reset_form = function() {
  const form = document.getElementById(this.target);
  if (form) {
    const textarea = form.querySelector("textarea");
    if (textarea) {
      const application = this.owner.application;
      const controller = application.getControllerForElementAndIdentifier(textarea, "textarea");
      if (controller) {
        controller.resetForm();
      }
    }
  }
};