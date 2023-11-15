defmodule Dictionary do
  alias Dictionary.Runtime.Server

  @type t :: Server.t()

  @spec random_word() :: String.t()
  defdelegate random_word(), to: Server

  @spec words_by_length(integer()) :: t
  defdelegate words_by_length(len), to: Server
end
