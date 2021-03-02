defmodule Hergetto.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :current_video, :string, default: "https://www.youtube.com/watch?v=Fkxox9xgL1U"
    field :loop, :boolean, default: false
    field :paused, :boolean, default: false
    field :playback_position, :integer, default: 0
    field :playback_rate, :float, default: 1.0
    field :playlist, {:array, :string}, default: []
    field :played_playlist, {:array, :string}, default: []
    field :uuid, Ecto.UUID
    field :owner, Ecto.UUID
    field :participants, {:array, Ecto.UUID}, default: []
    field :private, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [
      :playback_position,
      :playback_rate,
      :current_video,
      :playlist,
      :played_playlist,
      :paused,
      :loop,
      :uuid,
      :owner,
      :participants,
      :private
      ])
    |> validate_required([
      :uuid
    ])
  end
end
