import ScrollHelper from './scrollHelper'

export default class Chat {
    constructor(hook) {
        this.hook = hook;
    }

    shouldScroll() {
        const scrollHeightLimit = (this.hook.el.firstElementChild) ? (ScrollHelper.getElementHeight(this.hook.el.children[0]) * 10) : 300;
        return ScrollHelper.getScrollBottom(this.hook.el) < scrollHeightLimit;

    }

    scrollToBottom(forceScroll = false) {
        if (this.shouldScroll() || forceScroll ) {
            this.hook.el.scrollTop =  this.hook.el.scrollHeight;
        }
    }
}

