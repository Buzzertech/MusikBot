defmodule Musikbot.ImageScout.ScoutTest do
  use ExUnit.Case

  import Mock

  doctest Musikbot.ImageScout.Scout

  alias Musikbot.ImageScout.{Scout}

  describe "get_random_image" do
    setup %{} do
      image_scout = start_supervised!(Scout)

      success_response = """
      {
        "id": "nKEARsgmrqc",
        "created_at": "2018-02-12T12:52:30-05:00",
        "updated_at": "2019-06-07T01:05:15-04:00",
        "width": 4240,
        "height": 2832,
        "color": "#E9D7AA",
        "description": "FREE YOUR MIND … READ",
        "urls": {
          "raw": "https://images.unsplash.com/photo-1518457900604-5c973dffdedf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjc2NjkzfQ",
          "full": "https://images.unsplash.com/photo-1518457900604-5c973dffdedf?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjc2NjkzfQ",
          "regular": "https://images.unsplash.com/photo-1518457900604-5c973dffdedf?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjc2NjkzfQ",
          "small": "https://images.unsplash.com/photo-1518457900604-5c973dffdedf?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjc2NjkzfQ",
          "thumb": "https://images.unsplash.com/photo-1518457900604-5c973dffdedf?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjc2NjkzfQ",
          "custom": "https://images.unsplash.com/photo-1518457900604-5c973dffdedf?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1920&h=1080&fit=crop&ixid=eyJhcHBfaWQiOjc2NjkzfQ"
        },
        "links": {
          "self": "https://api.unsplash.com/photos/nKEARsgmrqc",
          "html": "https://unsplash.com/photos/nKEARsgmrqc",
          "download": "https://unsplash.com/photos/nKEARsgmrqc/download",
          "download_location": "https://api.unsplash.com/photos/nKEARsgmrqc/download"
        },
        "likes": 89,
        "liked_by_user": false,
        "user": {
          "id": "HYML7xMkVco",
          "updated_at": "2019-06-15T21:03:27-04:00",
          "username": "lordmaui",
          "name": "Chris Benson",
          "twitter_username": null,
          "portfolio_url": "http://hyperurl.co/3VMBiscayne",
          "bio": "If you’re downloading my work make sure you like it at least lol  and it would be dope to get a link to where the pictures helped you achieve whatever you’re  doing ..   email pakercenter08@gmail.com click the link in bio  support me please share .!",
          "location": "Fort Wayne ind ",
          "links": {
            "self": "https://api.unsplash.com/users/lordmaui",
            "html": "https://unsplash.com/@lordmaui",
            "photos": "https://api.unsplash.com/users/lordmaui/photos",
            "likes": "https://api.unsplash.com/users/lordmaui/likes",
            "portfolio": "https://api.unsplash.com/users/lordmaui/portfolio"
          },
          "instagram_username": "lordmaui1.5",
          "total_collections": 0,
          "total_likes": 412,
          "total_photos": 194
        },
        "downloads": 8563
      }
      """

      %{success_response: success_response, image_scout: image_scout}
    end

    test "should fetch a random image from unsplash", %{
      success_response: success_response,
      image_scout: image_scout
    } do
      with_mock HTTPoison,
        get: fn _api, _headers, _opts ->
          {:ok, %HTTPoison.Response{status_code: 200, body: success_response}}
        end do
        Scout.fetch_random_image(image_scout)
        image = Scout.get_image_state(image_scout)
        assert image["id"] == "nKEARsgmrqc"

        assert image["image_url"] ==
                 "https://images.unsplash.com/photo-1518457900604-5c973dffdedf?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1920&h=1080&fit=crop&ixid=eyJhcHBfaWQiOjc2NjkzfQ"
      end
    end
  end
end
