defmodule Dictionary.Impl.WordList do
  @type t :: list(String.t())

  @spec word_list() :: t
  def word_list do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec random_word(t) :: String.t()
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end

  @spec words_by_length(t, integer()) :: list(String.t())
  def words_by_length(word_list, len) do
    word_list
    |> Enum.map(&to_string/1)
    |> Enum.filter(fn x -> String.length(x) == len end)
  end
end
