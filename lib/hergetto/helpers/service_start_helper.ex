defmodule Hergetto.Helpers.ServiceStartHelper do
  require Logger

  def start(supervisor, service, room) do
    id = UUID.uuid4()

    case DynamicSupervisor.start_child(supervisor, {service, {id, room}}) do
      {:ok, _pid} ->
        {:ok, id}

      _ ->
        Logger.error("failed to start service: #{id}")
        {:error, :nostart}
    end
  end
end
