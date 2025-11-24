import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payment"
export default class extends Controller {
  static targets = ["selection", "additionalFields"]

  initialize() {
    this.showAdditionalFields()
  }

  showAdditionalFields() {
    const selection = this.selectionTarget.value

    this.additionalFieldsTargets.forEach((fields) => {
      fields.disabled = (fields.dataset.type !== selection)
      fields.hidden   = (fields.dataset.type !== selection)
    })
  }
}
