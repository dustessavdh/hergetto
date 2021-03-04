export default class Player {
    constructor(domId, hook) {
        this.hook = hook;
        this.eventQueue = [];
        window.onYouTubeIframeAPIReady = () => this.onIframeReady(domId)
        this.youtubeScriptTag = document.createElement("script")
        this.youtubeScriptTag.src = "//www.youtube.com/iframe_api"
        document.head.appendChild(this.youtubeScriptTag)
    }

    deconstruct() {
        this.hook = {};
        this.player.destroy()
        window["YT"].loading = 0
        window.onYouTubeIframeAPIReady = () => this.onIframeReady('aaa');
        document.head.removeChild(this.youtubeScriptTag)
    }

    onIframeReady(domId) {
        this.player = new YT.Player(domId, {
            events: {
                "onReady": (event => this.onPlayerReady(event)),
                "onStateChange": (event => setTimeout(() => {this.onPlayerStateChange(event)}, 0)),
                "onPlaybackRateChange": (event => this.onPlaybackRateChange(event)),
                "onError": (event => this.onPlayerError(event))
            }
        })

        return this.player
    }

    onPlayerReady(event) {
        this.player.mute()
        this.startEventQueue([YT.PlayerState.UNSTARTED, YT.PlayerState.BUFFERING, YT.PlayerState.UNSTARTED, YT.PlayerState.PLAYING])
        this.player.playVideo()
    }

    onPlayerStateChange(event) {
        switch (event.data) {
            case YT.PlayerState.UNSTARTED:
                break;
            case YT.PlayerState.ENDED:
                this.onPlayerEnded(event)
                break;
            case YT.PlayerState.PLAYING:
                this.onPlayerPlaying(event)
                break;
            case YT.PlayerState.PAUSED:
                this.onPlayerPaused(event)
                break;
            case YT.PlayerState.BUFFERING:
                break;
            case YT.PlayerState.CUED:
                break;
        }
    }

    onPlaybackRateChange(event) {
        this.hook.pushEvent("playback_rate_changed", {"playback_rate": event.data})
    }

    onPlayerError(event) {
        console.log(event)
    }

    onPlayerPlaying(event) {
        let playback_position = this.getCurrentTime()
        this.hook.pushEvent('play_video', {"playback_position": playback_position, "paused": false})
    }

    onPlayerPaused(event) {
        this.hook.pushEvent('pause_video', event)
    }

    onPlayerEnded(event) {
        this.hook.pushEvent('next_video', {"reason": "video ended"})
    }

    setCurrentVideoById(videoId, startTime) {
        this.startEventQueue([YT.PlayerState.UNSTARTED, YT.PlayerState.BUFFERING, YT.PlayerState.UNSTARTED, YT.PlayerState.PLAYING])
        this.player.loadVideoById(videoId, startTime)
    }

    setCurrentVideoByUrl(videoUrl, startTime) {
        this.startEventQueue([YT.PlayerState.UNSTARTED, YT.PlayerState.BUFFERING, YT.PlayerState.UNSTARTED, YT.PlayerState.PLAYING])
        this.player.loadVideoByUrl(videoUrl, startTime)
        this.player.seekTo(startTime)
    }

    playVideo(playback_position) {
        this.startEventQueue([YT.PlayerState.BUFFERING, YT.PlayerState.PLAYING])
        if (this.getCurrentTime() != playback_position) {
            this.seekTo(playback_position)
        }
        this.player.playVideo()
    }

    pauseVideo() {
        this.startEventQueue([YT.PlayerState.BUFFERING])
        this.player.pauseVideo()
    }

    setPlaybackRate(playbackRate) {
        this.player.setPlaybackRate(playbackRate)
    }

    getCurrentTime() {
        // return Math.ceil(this.player.getCurrentTime() * 1000)
        return Math.ceil(this.player.getCurrentTime() * 10)
    }

    seekTo(millsec) {
        // return this.player.seekTo(millsec / 1000)
        return this.player.seekTo(millsec / 10)
    }

    // See this as the documentation for it, yes it's bad
    // we set the onPlayerStateChange(event) to something else that does the following:
    // it looks at an [] with events
    // if that [] is empty it sets the onPlayerStateChange(event) back and calls it with that event
    // if not empty and the event it got exist, remove it from the list. then nothing
    // if an event is not in the list, clear the list then set the onPlayerStateChange(event) back and call that.
    // if buffering first then playing its ok
    // but if event queue is [buffering, playing], but playing gets called its ok and clear list, but any other event not okay
    startEventQueue(events) {
        this.eventQueue = events
        this.player.l.h[5] = (event => this.queuedPlayerStateChange(event))
        this.player.i.i.events.onStateChange = (event => this.queuedPlayerStateChange(event))
    }

    queuedPlayerStateChange(event) {
        if (this.eventQueue == []) {
            this.resumePlayerStateChange(event)
        } else if (event.data == YT.PlayerState.PLAYING && (this.eventQueue[0] == YT.PlayerState.BUFFERING && this.eventQueue[1] == YT.PlayerState.PLAYING)) {
            this.eventQueue = []
        } else if (event.data == this.eventQueue[0]) {
            this.eventQueue.splice(0, 1)
        } else if (event.data != this.eventQueue[0]) {
            this.eventQueue = []
            this.resumePlayerStateChange(event)
        }
    }

    resumePlayerStateChange(event) {
        this.player.l.h[5] = (event => this.onPlayerStateChange(event))
        this.player.i.i.events.onStateChange = (event => this.onPlayerStateChange(event))
        this.onPlayerStateChange(event)
    }
}