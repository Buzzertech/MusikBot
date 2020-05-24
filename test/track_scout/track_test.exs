defmodule Musikbot.TrackScout.TrackTest do
  use ExUnit.Case

  import Mock

  doctest Musikbot.TrackScout.Track

  describe "get_track_from_soundcloud" do
    setup do
      success_response = %{
        "id" => "7000",
        "tags_list" => ["cool", "song"],
        "user" => %{
          username: "Bvzzi",
          permalink_url: "https://soundcloud.com/bvzzi"
        },
        "permalink_url" => "https://soundcloud.com/track/7000"
      } |> Poison.encode!()

      {:ok, success_response: success_response}
    end

    test "should fetch track from soundcloud successfully", %{success_response: success_response} do
      with_mock HTTPoison,
        get: fn _api, _headers, _opts ->
          {:ok, %HTTPoison.Response{status_code: 200, body: success_response}}
        end do
          %{"id" => id, "permalink_url" => permalink_url} = Musikbot.TrackScout.Track.get_track_from_soundcloud(7000)
          assert id == "7000"
          assert permalink_url== "https://soundcloud.com/track/7000"
        end
    end
  end
end
