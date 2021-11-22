defmodule Hergetto.Helpers.ServiceStartHelper do
  def start(supervisor, service, room) do
    id = UUID.uuid4()
    case DynamicSupervisor.start_child(supervisor, {service, {id, room}}) do
      {:ok, _pid} ->
        {:ok, id}
      d ->
        IO.inspect(d)
        {:error, :nostart}
    end
  end
end
