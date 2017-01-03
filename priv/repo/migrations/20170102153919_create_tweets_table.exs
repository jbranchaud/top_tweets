defmodule TopTweets.Repo.Migrations.CreateTweetsTable do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :tweet_id, :bigint, null: false
      add :author, :varchar, null: false
      add :text_content, :varchar, null: false
      add :tweeted_at, :timestamptz, null: false
      add :retweeted_count, :integer, null: false
      add :favorited_count, :integer, null: false
      add :retweeted, :boolean, null: false, default: false
      add :data, :jsonb, null: false, default: "{}"
    end

    create unique_index(:tweets, [:tweet_id])
  end
end
