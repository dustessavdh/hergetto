import ScrollHelper from './scrollHelper'

export default class Chat {
    constructor(hook) {
        this.hook = hook;
    }

    /** 
     * TODO:
     *  when the user presses the button or presses enter: force scroll
     *  When the user presses the button or presses enter clear textfield
     *  Nice to Have: a scrolldown button.
     */
    shouldScroll() {
        const scrollHeightLimit = (this.hook.el.firstElementChild) ? (ScrollHelper.getElementHeight(this.hook.el.children[0]) * 10) : 300;
        if (ScrollHelper.getScrollBottom(this.hook.el) < 240) {
            return true;
        } else {
            return false;
        }
    }

    scrollToBottom(forceScroll = false) {
        if (this.shouldScroll() || forceScroll ) {
            this.hook.el.scrollTop =  this.hook.el.scrollHeight;
        }
    }
}

