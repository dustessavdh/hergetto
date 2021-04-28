defmodule Hergetto.Rooms.Video do
  @moduledoc """
  The video model.
  This model is used for form validation
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :add_video, :string

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:add_video])
    |> validate_required([:add_video])
    |> validate_length(:add_video, min: 5)
  end
end
