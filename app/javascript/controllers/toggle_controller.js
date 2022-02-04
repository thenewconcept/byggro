import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['element']

  switch() {
    if (this.elementTarget.classList.contains('hidden')) {
      this.elementTarget.classList.remove('hidden')
    } else {
      this.elementTarget.classList.add('hidden')
    }
  }
}
