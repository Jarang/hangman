defmodule Fuzzing do
  alias Fuzzing.Impl.Fuzzer

  defdelegate start(), to: Fuzzer
end
