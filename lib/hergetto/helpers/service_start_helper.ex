defmodule Hergetto.Helpers.ServiceStartHelper do
  def start(supervisor, service) do
    id = UUID.uuid4()
    case DynamicSupervisor.start_child(supervisor, {service, id}) do
      {:ok, _pid} ->
        {:ok, id}
      _ ->
        {:error, :nostart}
    end
  end
end
