defmodule HergettoWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.
  Also provides default presence handling. For example user precense on a topic.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :hergetto,
    pubsub_server: Hergetto.PubSub

  import Phoenix.LiveView
  alias Hergetto.Accounts.UserHelper, as: UH

  @doc """
  Starts presence tracking on a topic for live views.

  To keep the presence updated, you need to add the following code as well, but swap @topic for your subscibed topic:
  ```elixir
  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", topic: @topic, payload: diff}, socket) do
    HergettoWeb.Presence.handle_user_presence_diff(socket, diff)
  end
  ```

  ## Example:
      @impl true
      def mount(_params, session, socket) do
        {
          :ok,
          socket
          |> prepare_assigns(session, "Rooms")
          |> start_user_presence(@topic, self())
        }
      end
  """
  def start_user_presence(%{assigns: %{current_user: current_user}} = socket, topic, pid) do
    user = current_user || %{id: "GUEST" <> UUID.uuid4(), username: UH.generate_username()}

    if connected?(socket) do
      {:ok, _} =
        track(pid, topic, user.id, %{
          username: user.username,
          joined_at: :os.system_time(:seconds)
        })

      HergettoWeb.Endpoint.subscribe(topic)
    end

    socket
    |> assign(:users, %{})
    |> handle_user_joins(list(topic))
  end

  @doc """
  Handles user presence diffs.

  ## Example:
      @impl true
      def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", topic: @topic, payload: diff}, socket) do
        handle_user_presence_diff(socket, diff)
      end
  """
  def handle_user_presence_diff(socket, diff) do
    {
      :noreply,
      socket
      |> handle_user_leaves(diff.leaves)
      |> handle_user_joins(diff.joins)
    }
  end

  defp handle_user_joins(socket, joins) do
    Enum.reduce(joins, socket, fn {user, %{metas: [meta | _]}}, socket ->
      assign(socket, :users, Map.put(socket.assigns.users, user, meta))
    end)
  end

  defp handle_user_leaves(socket, leaves) do
    Enum.reduce(leaves, socket, fn {user, _}, socket ->
      assign(socket, :users, Map.delete(socket.assigns.users, user))
    end)
  end
end
