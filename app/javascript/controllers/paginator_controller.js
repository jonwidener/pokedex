import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="paginator"
export default class extends Controller {
  static targets = [ 'page', 'prev', 'next' ];
  static values = { 'page': Number, 'num-pages': Number };

  connect() {
    this.page = this.pageValue || 0;
  }

  prev() {
    this.page--;
    this.updateUI();
  }

  next() {
    this.page++;
    this.updateUI();
  }

  updateUI() {
    this.pageTargets.forEach( el => {
      if (el.id == this.page) {
        el.classList.remove('hidden');
      } else {
        el.classList.add('hidden');
      }
    });
    if (this.page == 0) {
      this.prevTarget.classList.add('hidden');
    } else {
      this.prevTarget.classList.remove('hidden');
    }
    if (this.page == this.numPagesValue - 1) {
      this.nextTarget.classList.add('hidden');
    } else {
      this.nextTarget.classList.remove('hidden');
    }
  }
}
