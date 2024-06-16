import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bonus", "field"];

  initialize() { 
    this.toggle(); 
  }

  toggle() {
    const bonus = this.bonusTarget.value;
    this.fieldTargets.forEach((field) => {
      if (field.dataset.for === bonus) {
        console.log('Show');
        field.classList.remove("hidden");
      } else {
        field.classList.add("hidden");
      }
    });
  }
}