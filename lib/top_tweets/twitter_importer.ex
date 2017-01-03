defmodule TopTweets.TwitterImporter do
  use Timex

  def import_tweets(username) do
    import_tweets(username, 200, nil, [])
    |> insert_tweets()
  end
  def import_tweets(username, count, max_id, acc) do
    tweets = case max_id do
      nil ->
        ExTwitter.user_timeline([screen_name: username, count: count])
      _ ->
        ExTwitter.user_timeline([screen_name: username, count: count, max_id: max_id])
    end

    case List.last(tweets) do
      nil ->
        acc ++ tweets
      last ->
        import_tweets(username, count, last.id - 1, acc ++ tweets)
    end
  end

  def insert_tweets(tweets) do
    tweets
    |> Enum.map(&bundle_tweet/1)
    |> insert_all_tweets()
  end

  def bundle_tweet(tweet_data) do
    [
      tweet_id: tweet_data.id,
      author: tweet_data.user.screen_name,
      text_content: tweet_data.text,
      tweeted_at: cast_timestamp(tweet_data.created_at),
      retweeted_count: tweet_data.retweet_count,
      favorited_count: tweet_data.favorite_count,
      retweeted: tweet_data.retweeted_status != nil,
      data: tweet_data
    ]
  end

  def cast_timestamp(timestamp) do
    [dow, mon, day, time, zone, year] = String.split(timestamp, " ")
    rfc1123 = Enum.join(["#{dow},", day, mon, year, time, zone], " ")

    rfc1123
    |> Timex.parse!("{RFC1123}")
    |> Ecto.DateTime.cast!()
  end

  def insert_all_tweets(tweets) do
    TopTweets.Repo.insert_all("tweets", tweets, returning: [:id])
  end
end
