# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :top_tweets, ecto_repos: [TopTweets.Repo]

config :top_tweets, TopTweets.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "top_tweets",
  hostname: "localhost",
  port: "5432"

config :extwitter, :oauth, [
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
]
