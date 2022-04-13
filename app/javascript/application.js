// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

Trix.config.blockAttributes.heading2 = {
  tagName: 'h2',
  terminal: true,
  breakOnReturn: true,
  group: false
}

addEventListener("trix-initialize", event => {
  const { toolbarElement } = event.target
  const h1Button = toolbarElement.querySelector("[data-trix-attribute=heading1]")
  h1Button.insertAdjacentHTML("afterend", `
    <button type="button" class="trix-button" data-trix-attribute="heading2" title="Heading 2" tabindex="-1" data-trix-active="">H2</button>
  `)
})