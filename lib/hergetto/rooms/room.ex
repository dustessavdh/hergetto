defmodule Hergetto.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :current_video, :string
    field :loop, :boolean, default: false
    field :paused, :boolean, default: false
    field :playback_position, :integer
    field :playback_rate, :float
    field :playlist, {:array, :string}
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:playback_position, :playback_rate, :current_video, :playlist, :paused, :loop, :uuid])
    |> validate_required([
      :playback_position,
      :playback_rate,
      :playlist,
      :paused,
      :loop,
      :uuid
    ])
  end
end
