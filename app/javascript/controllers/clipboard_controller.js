import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['source']

  copy (e) {
    e.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.dataset.value)
  }
}