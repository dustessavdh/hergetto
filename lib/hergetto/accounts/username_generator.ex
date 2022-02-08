defmodule Hergetto.Accounts.UsernameGenerator do
  @adjectives ~w(
    autumn hidden bitter misty silent empty dry dark summer
    icy delicate quiet white cool spring winter patient
    twilight dawn crimson wispy weathered blue billowing
    broken cold damp falling frosty green long late lingering
    bold little morning muddy old red rough still small
    sparkling throbbing shy wandering withered wild black
    young holy solitary fragrant aged snowy proud floral
    restless divine polished ancient purple lively nameless
  )

  @nouns ~w(
    waterfall river breeze moon rain wind sea morning
    snow lake sunset pine shadow leaf dawn glitter forest
    hill cloud meadow sun glade bird brook butterfly
    bush dew dust field fire flower firefly feather grass
    haze mountain night pond darkness snowflake silence
    sound sky shape surf thunder violet water wildflower
    wave water resonance sun wood dream cherry tree fog
    frost voice paper frog smoke star hamster log
  )

  @max_id 9999

  @guest_id "GUEST"

  def generate_username_with_tag do
    username = generate_username()
    id = generate_tag()

    [username, id] |> Enum.join("#")
  end

  def generate_guest_with_tag do
    username = generate_username()
    id = @guest_id

    [username, id] |> Enum.join("#")
  end

  def generate_username do
    adjective = @adjectives |> Enum.random
    noun = @nouns |> Enum.random
    [adjective, noun] |> Enum.join("")
  end

  def generate_tag do
    :rand.uniform(@max_id)
  end
end
