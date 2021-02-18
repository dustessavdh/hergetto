import Player from './player'

let Hooks = {}

// Player
Hooks.vid_player = {
    mounted() {
        let player = new Player('player', this)
        this.handleEvent('change_vid', (event) => {
            console.log('change video:', event)
            player.setCurrentVideoById(event.cur_vid)
        })

        this.handleEvent('play_video', (event) => {
            console.log('play video:', event)
            player.playVideo(event.playback_position)
        })

        this.handleEvent('pause_video', (event) => {
            console.log('pause video:', event)
            player.pauseVideo()
        })

        this.handleEvent('change_playback_rate', (event) => {
            console.log('change playback rate:', event)
            player.setPlaybackRate(event.playback_rate)
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