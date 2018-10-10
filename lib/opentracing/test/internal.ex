defmodule OpenTracing.Test.Internal do
  @moduledoc """
  Gives access to traced spans. This is an internal module. It should only be
  used in the tests.
  """

  use Agent

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def spans() do
    Agent.get(__MODULE__, &(&1))
  end

  def add_span(span) do
    Agent.update(__MODULE__, fn spans -> spans ++ [span] end)
  end
end
