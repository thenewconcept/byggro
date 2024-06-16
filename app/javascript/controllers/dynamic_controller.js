import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["payout", "field"];

  initialize() {
    this.toggle();
  }

  toggle() {
    const payout = this.payoutTarget.value;
    this.fieldTargets.forEach((field) => {
      if (field.dataset.for === payout) {
        console.log('Show');
        field.classList.remove("hidden");
      } else {
        field.classList.add("hidden");
      }
    });
  }
}