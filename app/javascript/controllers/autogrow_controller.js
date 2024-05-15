import TextareaAutogrow from 'stimulus-textarea-autogrow'
import { debounce } from "lodash-es"; // Assuming lodash is installed for debouncing

export default class extends TextareaAutogrow {
  connect() {
    super.connect()
    setInterval(() => {
      this._autogrow()
    }, 200)    
  }

  _autogrow() {
    this.autogrow()
  }

  autogrow () {
    var scrollTop = document.documentElement.scrollTop
    this.element.style.height = 'auto' // Force re-print before calculating the scrollHeight value.
    this.element.style.height = this.element.scrollHeight + 'px'
    document.documentElement.scrollTop = scrollTop;
  }
}

console.log("Up")
