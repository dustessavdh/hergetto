let Player = {
    player: null,
    hook: null,

    init(domId, hook) {
        this.hook = hook;
        window.onYouTubeIframeAPIReady = () => this.onIframeReady(domId)
        let youtubeScriptTag = document.createElement("script")
        youtubeScriptTag.src = "//www.youtube.com/iframe_api"
        document.head.appendChild(youtubeScriptTag)
    },

    onIframeReady(domId) {
        console.log('iframe ready')
        this.player = new YT.Player(domId, {
            events: {
                "onReady": (event => this.onPlayerReady(event)),
                "onStateChange": (event => this.onPlayerStateChange(event)),
                "onPlaybackRateChange": (event => this.onPlaybackRateChange(event))
            }
        })
    },

    onPlayerReady(event) {
        this.player.playVideo()
    },

    onPlayerStateChange(event) {
        player.removeEventListener("onStateChange", (event => this.onPlayerStateChange(event)))
        switch (event.data) {
            case YT.PlayerState.ENDED:
                console.log('ended')
                break;
            case YT.PlayerState.PLAYING:
                    this.onPlayerPlaying(event)
                break;
            case YT.PlayerState.PAUSED:
                    this.onPlayerPaused(event)
                break;
            case YT.PlayerState.BUFFERING:
                console.log('buffering')
                break;
            case YT.PlayerState.CUED:
                console.log('video cued')
                break;
        }
        player.addEventListener("onStateChange", (event => this.onPlayerStateChange(event)))
        console.log('after break')
    },

    onPlayerPlaying(event) {
        let playback_position = this.getCurrentTime()
        this.hook.pushEvent('play_video', {"playback_position": playback_position, "paused": false})
    },

    onPlayerPaused(event) {
        console.log('player paused')
        this.hook.pushEvent('pause_video', event)
    },

    onPlaybackRateChange(event) {
        console.log('playback:', event)
        this.hook.pushEvent("playback_rate_changed", {})
    },

    setCurrentVideoById(videoId) {
        this.player.loadVideoById(videoId, 0)
    },

    setCurrentVideoByUrl(videoUrl) {
        this.player.loadVideoByUrl(videoUrl, 0)
    },

    playVideo(playback_position) {
        if (this.getCurrentTime() != playback_position) {
            this.seekTo(playback_position)
        }
        this.player.playVideo()
    },

    pauseVideo() {
        this.player.pauseVideo()
    },

    setPlaybackRate(playbackRate) {
        this.player.setPlaybackRate(playbackRate)
    },

    getCurrentTime() {
        // return Math.floor(this.player.getCurrentTime() * 1000)
        // return Math.floor(this.player.getCurrentTime() * 100)
        return Math.floor(this.player.getCurrentTime())
    },

    seekTo(millsec) {
        // return this.player.seekTo(millsec / 1000)
        // return this.player.seekTo(millsec / 100)
        return this.player.seekTo(millsec)
    }
}

export default Player