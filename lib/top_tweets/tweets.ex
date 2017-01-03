defmodule TopTweets.Tweets do
  import Ecto.Query
  import TopTweets.Ecto.CustomFunctions

  alias TopTweets.Ecto.DateTimeHelper

  def get_most_retweeted_tweets(author, opts \\ []) do
    from(t in original_tweets(author),
    select: {
      t.tweet_id,
      t.retweeted_count,
      t.text_content
    },
    where: between(t.tweeted_at, ^DateTimeHelper.beginning_of_year(2016), ^DateTimeHelper.end_of_year(2016)),
    order_by: [desc: t.retweeted_count])
    |> get_tweet_data_by(opts)
  end

  def get_most_favorited_tweets(author, opts \\ []) do
    from(t in original_tweets(author),
    select: {
      t.tweet_id,
      t.favorited_count,
      t.text_content
    },
    where: between(t.tweeted_at, ^DateTimeHelper.beginning_of_year(2016), ^DateTimeHelper.end_of_year(2016)),
    order_by: [desc: t.favorited_count])
    |> get_tweet_data_by(opts)
  end

  defp get_tweet_data_by(select, opts \\ []) do
    limit = opts[:limit] || 10

    from(t in select,
    limit: ^limit)
    |> TopTweets.Repo.all
  end

  defp original_tweets(author) do
    from t in "tweets",
    where: t.author == ^author
       and not t.retweeted
  end
end
