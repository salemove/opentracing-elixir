defmodule OpenTracing.Tracer do
  @moduledoc """
  Tracer is the entry point API between instrumentation code and the tracing
  implementation.

  This module defines the public Tracer API.

  See http://www.opentracing.io for more information.
  """

  @type format :: :http_headers
  @type span :: pid
  @type scope :: pid
  @type span_context :: pid

  @callback active_span() :: pid | nil

  @callback start_active_scope(String.t()) :: scope
  @callback start_active_scope(String.t(), map) :: scope
  @callback start_active_scope(String.t(), function) :: scope
  @callback start_active_scope(String.t(), map, function) :: scope

  @callback close_scope(scope) :: scope

  @callback get_span(scope) :: span

  @callback start_span(String.t()) :: span
  @callback start_span(String.t(), map) :: span

  @callback finish_span(span) :: :ok

  @callback inject(span_context, format, map) :: map

  @callback extract(format, map) :: map
end
