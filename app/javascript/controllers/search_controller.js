import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'form', 'clear']

  change() {
    if (this.inputTarget.value.length === 0) {
      this.formTarget.submit()
    } 
  }

  connect() {
    let temp_value = this.inputTarget.value; 
    this.inputTarget.value='';
    this.inputTarget.value = temp_value;
  }
}