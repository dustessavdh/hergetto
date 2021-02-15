defmodule HergettoWeb.ClickerHelper do
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Hergetto.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(Hergetto.PubSub, @topic, message)
  end
end
