defmodule Musikbot.TrackScout do
  alias Musikbot.TrackScout.{Track}

  @max_track_id 784514266

  def get_random_track do
    random_track_id = (0..@max_track_id) |> Enum.random()

    case Track.get_track_from_soundcloud(random_track_id) do
      {:ok, track} ->
        track
      {:error, _} ->
        get_random_track()
      end
    end

end
