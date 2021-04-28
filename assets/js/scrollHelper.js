export default class ScrollHelper {
    static getElementHeight(element) {
        return element.clientHeight;
    }

    static getElementScrollHeight(element) {
        return element.scrollHeight;
    }

    static getScrollHeight(element) {
        return this.getElementScrollHeight(element) - this.getElementHeight(element);
    }

    static getScrollTop(element) {
        return element.scrollTop;
    }

    static getScrollTopPercent(element) {
        const scrollTopPercent = this.getScrollBottom(element) / this.getScrollHeight(element) * 100;
        return Math.round(scrollTopPercent * 100) / 100;
    }

    static getScrollBottom(element) {
        return this.getScrollHeight(element) - this.getScrollTop(element);
    }

    static getScrollBottomPercent(element) {
        const scrollBottomPercent = this.getScrollTop(element) / this.getScrollHeight(element) * 100;
        return Math.round(scrollBottomPercent * 100) / 100;
    }

    static getScrollThumbHeight(element) {
        const elementHeight = Math.pow(this.getElementHeight(element), 2);
        const scrollThumbHeight = elementHeight / this.getElementScrollHeight(element);
        return parseInt(scrollThumbHeight.toFixed(0), 10);
    }

    static getScrollThumbSize(element) {
        const thumbSize = this.getScrollThumbHeight(element) / this.getElementHeight(element) * 100;
        return Math.round(thumbSize * 100) / 100;
    }
}