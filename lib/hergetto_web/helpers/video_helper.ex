defmodule HergettoWeb.VideoHelper do
  alias Hergetto.Rooms

  def set_current_video(index, playlist, changes) do
    case Integer.parse(index) do
      {index, _} ->
        Map.put(changes, :current_video, Enum.at(playlist, index))
    end
  end

  def delete_video(changes, playlist, index) do
    case Integer.parse(index) do
      {index, _} ->
        Map.put(changes, :playlist, List.delete_at(playlist, index))
    end
  end

  def add_video(playlist, video, changes) do
    Map.put(changes, :playlist, playlist ++ [video])
  end

  def change_video_state(paused?) do
    %{paused: paused?}
  end

  def change_video_state(paused?, playback_position) do
    %{paused: paused?, playback_position: playback_position}
  end

  def change_playback_rate(playback_rate) do
    %{"playback_rate" => playback_rate}
  end

  def save_changes(changes, room) do
    Rooms.update_room(room, changes)
  end

  def get_yt_id(url) do
    %{id: id} = Videx.parse(url)
    id
  end
end
