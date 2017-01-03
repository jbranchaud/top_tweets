defmodule TopTweets.Ecto.DateTimeHelper do
  use Timex

  def beginning_of_year() do
    beginning_of_year(Timex.today.year)
  end
  def beginning_of_year(year) do
    year
    |> Timex.beginning_of_year()
    |> Timex.to_datetime()
    |> Ecto.DateTime.cast!()
  end

  def end_of_year() do
    end_of_year(Timex.today.year)
  end
  def end_of_year(year) do
    year
    |> Timex.end_of_year()
    |> Timex.shift(days: 1)
    |> Timex.to_datetime()
    |> Ecto.DateTime.cast!()
  end
end
