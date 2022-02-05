import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['description']

  toggle(e) {
    console.log(e);
    // Send update to server
  }
}