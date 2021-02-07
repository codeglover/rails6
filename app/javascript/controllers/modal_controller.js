// modal_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ["template", "modal"];

    connect() {
        this.element.insertAdjacentHTML("beforeend", this.templateTarget.innerHTML);
    }

    show(e) {
        e.preventDefault();

        // this is a stand-in for an external show method, e.g. in Bootstrap or SemanticUI
        this.modalTarget.classList.remove("invisible");
        this.modalTarget.classList.add("visible");
    }

    hide(e) {
        e.preventDefault();

        // this is a stand-in for an external hide method that will
        // yank the modal HTML off your page
        this.element.removeChild(this.element.lastElementChild);

        this.element.insertAdjacentHTML("beforeend", this.templateTarget.innerHTML);
    }
}