defmodule OpenTracing.Test.Span do
  @moduledoc nil

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(_) do
    {:ok, Map.new}
  end

  def handle_call(:finish, _from, state) do
    state = Map.put(state, :finished, true)
    {:reply, :ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def get_state(span) do
    GenServer.call(span, :get_state)
  end

  def finish(span) do
    GenServer.call(span, :finish)
  end
end
