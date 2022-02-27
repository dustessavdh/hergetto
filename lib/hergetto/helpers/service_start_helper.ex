defmodule Hergetto.Helpers.ServiceStartHelper do
  @moduledoc false
  require Logger

  def start(supervisor, service, room) do
    with id <- UUID.uuid4(),
         {:ok, _pid} <- DynamicSupervisor.start_child(supervisor, {service, {id, room}}) do
      {:ok, id}
    else
      _ ->
        Logger.error("failed to start service: #{service}")
        {:error, :nostart}
    end
  end
end
