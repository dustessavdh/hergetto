import Player from './player'

let Hooks = {}

// Player
Hooks.vid_player = {
    mounted() {
        Player.init('player', this)
        this.handleEvent('change_vid', (event) => {
            console.log('change video:', event)
            Player.setCurrentVideoById("ggqI-HH8yXc")
        })

        this.handleEvent('play_video', (event) => {
            console.log('play video:', event)
            Player.playVideo(event.playback_position)
        })

        this.handleEvent('pause_video', (event) => {
            console.log('pause video:', event)
            Player.pauseVideo()
        })

        this.handleEvent('change_playback_rate', (event) => {
            console.log('change playback rate:', event)
            Player.setPlaybackRate(event.playback_rate)
        })
    },

    updated() {
        console.log('updated')
    },

    destroyed() {
        console.log('destroyed')
    }
}

export default Hooks