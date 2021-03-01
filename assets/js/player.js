export default class Player {
    constructor(domId, hook) {
        this.hook = hook;
        window.onYouTubeIframeAPIReady = () => this.onIframeReady(domId)
        let youtubeScriptTag = document.createElement("script")
        youtubeScriptTag.src = "//www.youtube.com/iframe_api"
        document.head.appendChild(youtubeScriptTag)
    }

    onIframeReady(domId) {
        console.log('iframe ready')
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
        this.pausePlayerStateChange(500)
        this.player.mute()
        console.log('player ready')
        this.player.playVideo()
    }

    onPlayerStateChange(event) {
        console.log('player state changed!', event.data)
        switch (event.data) {
            case YT.PlayerState.UNSTARTED:
                console.log('unstarted')
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
                console.log('buffering')
                break;
            case YT.PlayerState.CUED:
                console.log('video cued')
                break;
        }
    }

    onPlaybackRateChange(event) {
        console.log('playback:', event)
        this.hook.pushEvent("playback_rate_changed", {"playback_rate": event.data})
    }

    onPlayerError(event) {
        console.log(event)
    }

    onPlayerPlaying(event) {
        console.log('player playing')
        let playback_position = this.getCurrentTime()
        this.hook.pushEvent('play_video', {"playback_position": playback_position, "paused": false})
    }

    onPlayerPaused(event) {
        console.log('player paused')
        this.hook.pushEvent('pause_video', event)
    }

    onPlayerEnded(event) {
        console.log('Player ended')
        this.hook.pushEvent('next_video', {"reason": "video ended"})
    }

    setCurrentVideoById(videoId, startTime) {
        this.player.loadVideoById(videoId, startTime)
    }

    setCurrentVideoByUrl(videoUrl, startTime) {
        this.player.loadVideoByUrl(videoUrl, startTime)
    }

    playVideo(playback_position) {
        this.pausePlayerStateChange(250)
        if (this.getCurrentTime() != playback_position) {
            this.seekTo(playback_position)
        }
        this.player.playVideo()
    }

    pauseVideo() {
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

    pausePlayerStateChange(millsec) {
        this.player.l.h[5] = (event => setTimeout(() => {this.onPlayerStateChangeTimeout(event)}, millsec))
        this.player.i.i.events.onStateChange = (event => setTimeout(() => {this.onPlayerStateChangeTimeout(event)}, millsec))
    }

    onPlayerStateChangeTimeout(event) {
        console.log('player state changed, but was in timeout!', event.data)
        this.player.l.h[5] = (event => this.onPlayerStateChange(event))
        this.player.i.i.events.onStateChange = (event => this.onPlayerStateChange(event))
    }
}