defmodule Musikbot.TrackScout.ScoutTest do
  use ExUnit.Case

  import Mock

  doctest Musikbot.TrackScout.Scout

  alias Musikbot.TrackScout.{Scout}

  describe "get_random_track" do
    setup %{} do
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

      {:ok, success_response: success_response}
    end

    test "should fetch the track for a random track id", %{success_response: success_response} do
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
        {:ok, track} = Scout.get_random_track()
        assert track == expected_result
      end
    end

    test "should handle failures with retries and return the error post exhaustion of retry limit" do
      with_mock HTTPoison,
        get: fn _api, _headers, _opts ->
          {:error, "Not found"}
        end do
          assert {:error, "Unable to fetch track"} == Scout.get_random_track()
        end
    end
  end
end
