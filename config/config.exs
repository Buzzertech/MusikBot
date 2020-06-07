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

config :musikbot, :misc,
  svg_template: """
  <style>html,body{margin: 0; padding: 0;}</style>
  <link href="https://fonts.googleapis.com/css?family=Poppins&display=swap&text={{song_name}}{{artist_name}}" rel="stylesheet">
  <svg viewBox="0 0 1920 1080" lang="en-US" xmlns="http://www.w3.org/2000/svg">
  	<defs>
  		<linearGradient id="bottomGrad" x1="0%" y1="0%" x2="0%" y2="100%">
  			<stop offset="0%" style="stop-color:rgb(255,255,255);stop-opacity:0" />
  			<stop offset="100%" style="stop-color:rgb(0,0,0);stop-opacity:.8;" />
  		</linearGradient>
  	</defs>
  	<image href="{{bg_url}}" x="0" y="0" width="100%" height="100%" />
  	<rect x="0" y="40%" width="100%" height="60%" fill="url(#bottomGrad)"/>
  	<text x="${textX}" style="font-family: 'Poppins', arial; font-weight: bold; font-size: 5em;" y="90%" fill="white">{{song_name}}</text>
  	<text x="${textX}" style="font-family: 'Poppins', arial; font-size: 3em; font-weight: 300;" y="95%" fill="white">{{artist_name}}</text>
  </svg>
  """
