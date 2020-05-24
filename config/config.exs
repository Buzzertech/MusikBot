# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :musikbot, :soundcloud,
  origin: "https://api-v2.soundcloud.com",
  get_track_api: "/tracks",
  client_id: System.get_env("SOUNDCLOUD_CLIENT_ID")

config :musikbot, :unsplash,
  origin: "https://api.unsplash.com",
  get_random_photo_api: "/photos/random"
