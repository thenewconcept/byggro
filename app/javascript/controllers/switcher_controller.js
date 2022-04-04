import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  switch(event) {
    Turbo.visit(event.target.value)
  }
}
