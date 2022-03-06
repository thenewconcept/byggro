import { Controller } from "@hotwired/stimulus"
import HourParser from "hour-parser"

export default class extends Controller {
  static targets = [ "source", "holder" ]
  format() {
    const value = this.sourceTarget.value;
    this.sourceTarget.value = HourParser.toHHMM(value);
    this.holderTarget.value = HourParser.toDecimal(value);
  }
}