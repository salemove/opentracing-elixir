defmodule OpenTracing.Test.Scope do
  @moduledoc nil

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(%{span: span}) do
    {:ok, %{span: span}}
  end

  def handle_call(:close, _from, state) do
    state = Map.put(state, :closed, true)
    {:reply, :ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def get_state(scope) do
    GenServer.call(scope, :get_state)
  end

  def close(scope) do
    GenServer.call(scope, :close)
  end
end
