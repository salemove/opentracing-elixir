defmodule OpenTracing.Test.Tracer do
  @moduledoc """
  Basic in memory tracer implementation. Useful for testing.
  """

  @behaviour OpenTracing.Tracer

  alias OpenTracing.Test.Span
  alias OpenTracing.Test.Scope
  alias OpenTracing.Test.Internal
  alias OpenTracing.Test.ScopeStack

  @impl true
  def active_span do
    scope = ScopeStack.peek
    if scope do
      get_span(scope)
    end
  end

  @impl true
  def start_active_scope(operation_name) do
    span = start_span(operation_name)
    {:ok, scope} = Scope.start_link(%{span: span})
    ScopeStack.add(scope)
    scope
  end

  @impl true
  def start_active_scope(_operation_name, options) when is_map(options) do
    nil
  end

  @impl true
  def start_active_scope(operation_name, action) when is_function(action) do
    scope = start_active_scope(operation_name)
    action.(scope)
    close_scope(scope)
  end

  @impl true
  def start_active_scope(_operation_name, _options, _action) do
    nil
  end

  @impl true
  def close_scope(scope) do
    Scope.close(scope)
    ScopeStack.pop()
    scope
  end

  @impl true
  def get_span(scope) do
    %{span: span} = OpenTracing.Test.Scope.get_state(scope)
    span
  end

  @impl true
  def start_span(operation_name) do
    {:ok, span} =
      Span.start_link(%{
        operation_name: operation_name
      })

    Internal.add_span(span)
    span
  end

  @impl true
  def finish_span(span) do
    OpenTracing.Test.Span.finish(span)
  end

  @impl true
  def start_span(_operation_name, _options) do
    nil
  end

  @impl true
  def inject(_context, _format, _carrier) do
    nil
  end

  @impl true
  def extract(_format, _carrier) do
    nil
  end
end
