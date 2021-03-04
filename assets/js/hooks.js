import Player from './player'

let Hooks = {}
let player = {};
// Player
Hooks.vid_player = {
    mounted() {
        player = new Player(this.el.firstChild.nextElementSibling.id, this)
        this.handleEvent('change_vid', (event) => {
            player.setCurrentVideoById(event.cur_vid, event.start_time)
        })

        this.handleEvent('play_video', (event) => {
            player.playVideo(event.playback_position)
        })

        this.handleEvent('pause_video', (event) => {
            player.pauseVideo()
        })

        this.handleEvent('change_playback_rate', (event) => {
            player.setPlaybackRate(event.playback_rate)
        })

        this.handleEvent('update_playback_position', (event) => {
            this.pushEvent('update_playback_position', {'playback_position': player.getCurrentTime()})
        })
    },

    destroyed() {
        if (player.player) {
            player.deconstruct()
        }
        player = {}
    }
}

export default Hooks