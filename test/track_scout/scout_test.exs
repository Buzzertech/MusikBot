defmodule Musikbot.TrackScout.ScoutTest do
  use ExUnit.Case

  import Mock

  doctest Musikbot.TrackScout.Scout

  alias Musikbot.TrackScout.{Scout}

  describe "get_random_track" do
    setup %{} do
      track_scout = start_supervised! Scout

      transcoding = %{
        "url" => "https://example-stream.com/",
        "preset" => "mp3_0_1",
        "duration" => 139_886,
        "snipped" => false,
        "format" => %{
          "protocol" => "progressive",
          "mime_type" => "audio/mpeg"
        },
        "quality" => "sq"
      }

      success_response =
        [
          %{
            "id" => "7000",
            "tags_list" => ["cool", "song"],
            "media" => %{
              "transcodings" => [transcoding]
            },
            "user" => %{
              "username" => "Bvzzi",
              "permalink_url" => "https://soundcloud.com/bvzzi"
            },
            "permalink_url" => "https://soundcloud.com/track/7000"
          }
        ]
        |> Poison.encode!()

      %{success_response: success_response, track_scout: track_scout}
    end

    test "should fetch the track for a random track id", %{success_response: success_response, track_scout: track_scout} do
      expected_result = %{
        "id" => "7000",
        "tags_list" => ["cool", "song"],
        "stream_url" => "https://example-stream.com/",
        "user" => %{
          "username" => "Bvzzi",
          "permalink_url" => "https://soundcloud.com/bvzzi"
        },
        "permalink_url" => "https://soundcloud.com/track/7000"
      }

      with_mock HTTPoison,
        get: fn _api, _headers, _opts ->
          {:ok, %HTTPoison.Response{status_code: 200, body: success_response}}
        end do
        Scout.fetch_random_track(track_scout)
        track = Scout.get_random_track(track_scout)
        assert track == expected_result
      end
    end
  end
end
