import { Controller } from "@hotwired/stimulus"
import HourParser from "hour-parser"

export default class extends Controller {
  static targets = [ "source", "holder" ]

  connect() {
    const value = this.holderTarget.value;
    this.sourceTarget.value = HourParser.toHHMM(value);
  }

  update() {
    const value = this.sourceTarget.value;
    this.holderTarget.value = HourParser.toDecimal(value);
  }

  format() {
    const value = this.sourceTarget.value;
    this.sourceTarget.value = HourParser.toHHMM(value);
    this.update()
  }
}