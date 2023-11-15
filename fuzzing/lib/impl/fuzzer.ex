defmodule Fuzzing.Impl.Fuzzer do
  def start() do
    IO.puts("Fuzzer starting")
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    possible_words = Dictionary.words_by_length(length(tally.letters))
    IO.inspect(possible_words)

    try_move({game, tally, possible_words})
  end

  # ----------------------------------------------------------------------------

  def try_move({_game, tally = %{game_state: :won}, _possible_words}) do
    formatted_text = IO.ANSI.green() <> "Too easy" <> IO.ANSI.reset()
    IO.puts(formatted_text)
    IO.puts("The word was: #{tally.letters}")
  end

  def try_move({_game, tally = %{game_state: :lost}, _possible_words}) do
    formatted_text = IO.ANSI.red() <> "Unlucky" <> IO.ANSI.reset()
    IO.puts(formatted_text)
    IO.puts("The word was: #{tally.letters}")
    IO.puts("The closest we got was: #{tally.used}")
  end

  def try_move({game, tally, possible_words}) do
    IO.puts("Letters tested: #{tally.used}")
    updated_possible_words = words_with_letters(tally, possible_words)
    IO.puts("Possible words: #{length(updated_possible_words)}")

    # guess =
    #  tally.used
    #  |> random_guess()

    guess = random_guess_from_words(tally, updated_possible_words)
    IO.puts("About to guess with: #{guess}")

    {updated_game, updated_tally} = Hangman.make_move(game, guess)
    try_move({updated_game, updated_tally, updated_possible_words})
  end

  # ----------------------------------------------------------------------------

  def random_guess(used_letters) do
    Enum.to_list(?a..?z)
    |> to_string()
    |> String.split("")
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.filter(fn x -> x not in used_letters end)
    |> Enum.take_random(1)
    |> to_string
  end

  def random_guess_from_words(tally, words) do
    used_letters = tally.used

    words
    |> Enum.map(fn x ->
      x
      |> String.split("")
      |> Enum.filter(&(&1 != ""))
      |> Enum.filter(fn x -> x not in used_letters end)
      |> MapSet.new()
    end)
    |> Enum.flat_map(& &1)
    |> MapSet.new()
    |> Enum.take_random(1)
    |> to_string()
  end

  def normalize_letters(letter_list) do
    letter_list
    |> Enum.filter(&(&1 != "_"))
    |> Enum.map(fn x ->
      x
      |> String.split("")
      |> Enum.filter(&(&1 != ""))
      |> Enum.sort()
      |> Enum.join("")
    end)
    |> Enum.join("")
  end

  def diff(used, letters) do
    used = used |> String.split("") |> Enum.sort() |> Enum.filter(&(&1 != ""))
    letters = letters |> String.split("") |> Enum.sort() |> Enum.filter(&(&1 != ""))

    used -- letters
  end

  def words_with_letters(tally, all_words) do
    used_letters = tally.used |> normalize_letters()
    correct_letters = tally.letters |> normalize_letters()
    IO.inspect(used_letters)
    IO.inspect(correct_letters)
    non_valid_letters = diff(used_letters, correct_letters)
    IO.puts("Non_valid_letters: #{non_valid_letters}")

    all_words
    # |> Enum.filter(fn x -> contains_correct_letters?(x, correct_letters) end)
    |> Enum.filter(fn x -> contains_correct_letter_at_location?(x, tally.letters) end)
    |> Enum.filter(fn x -> !contains_non_valid_letters?(x, non_valid_letters) end)
  end

  def contains_correct_letters?(word, letters) do
    # ["a", "b", "c"]
    letter_list = letters |> String.split("") |> Enum.filter(&(&1 != ""))
    temp = Enum.map(letter_list, fn x -> String.contains?(word, x) end)
    Enum.all?(temp)
  end

  def contains_non_valid_letters?(word, non_valid_letters) do
    # ["a", "b", "c"]
    temp = Enum.map(non_valid_letters, fn x -> String.contains?(word, x) end)
    Enum.any?(temp)
  end

  def contains_correct_letter_at_location?(word, letters_with_underscore) do
    # ["a", "b", "c"]

    word_list = word |> String.split("") |> Enum.filter(&(&1 != ""))

    Enum.zip(word_list, letters_with_underscore)
    |> Enum.all?(fn {a, b} -> characters_match?(a, b) end)
  end

  def characters_match?(_a, _b = "_"), do: true
  def characters_match?(a, b), do: a == b
end
