import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['element']

  switch(event) {
    const el = document.getElementById(event.params.id)
    if (el.classList.contains('hidden')) {
      el.classList.remove('hidden')
    } else {
      el.classList.add('hidden')
    }
  }
}
