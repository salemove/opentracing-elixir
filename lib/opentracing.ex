defmodule OpenTracing do
  @moduledoc """
  Documentation for OpenTracing.
  """

  @tracer Application.fetch_env!(:opentracing, :global_tracer)

  defdelegate active_span(), to: @tracer

  # TODO: why do we need scope? Could we just use span without wrapping it in
  # scope? We're passing the process id around anyway so no thread safety
  # issues.
  # TODO: we also need activate_span(span) :: scope
  # This is for passing a span to a other process.

  defdelegate start_active_scope(operation_name), to: @tracer
  defdelegate start_active_scope(operation_name, options_or_action), to: @tracer
  defdelegate start_active_scope(operation_name, options, action), to: @tracer

  defdelegate close_scope(scope), to: @tracer

  defdelegate get_span(scope), to: @tracer

  defdelegate start_span(operation_name), to: @tracer
  defdelegate start_span(operation_name, options), to: @tracer

  defdelegate finish_span(span), to: @tracer

  defdelegate inject(context, format, carrier), to: @tracer

  defdelegate extract(format, carrier), to: @tracer

  def global_tracer(), do: @tracer
end
