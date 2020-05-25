defmodule Musikbot.TrackScout.Scout do
  alias Musikbot.TrackScout.{Track}

  @max_track_id 784514266

  def get_random_track(retry \\ 3) do
    if (retry == 0) do
      {:error, "Unable to fetch track"}
    end

    random_track_id = (0..@max_track_id) |> Enum.random()

    case Track.get_track_from_soundcloud(random_track_id) do
      {:ok, track} ->
        {:ok, track}
      {:error, _} ->
        get_random_track(retry - 1)
      end
    end

end
