# OpenTracing

## Installation

Add `opentracing` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opentracing, "~> 0.1.0"}
  ]
end
```

You will also need a tracer implementation.

## Usage

### Configure OpenTracing

```elixir
config :opentracing,
  global_tracer: Zipkin

config :zipkin, # or whatever opentracing compatibile tracer you wish to use
  url: "http://localhost:9411"
```

### Starting a new Span

The common case starts a `Scope` that's automatically registered for intra-process propagation.

Note that `start_active_scope(...)` automatically finishes the span on `Scope#close`.

Creating a simple span:
```elixir
  scope = OpenTracing.start_active_scope("operation_name")
  span = OpenTracing.get_span(scope)

  # Do some things

  OpenTracing.close_scope(scope)
```

It's possible to pass a function. The span will be closed after the function has been executed.
```elixir
  OpenTracing.start_active_scope("operation_name", fn scope ->
    span = OpenTracing.get_span(scope)
    # Do some things
  end)
```

You can also always access active span using `OpenTracing.active_span`.

It is also possible to activate a span manually:
```elixir
  span = OpenTracing.start_span("operation name")

  scope = OpenTracing.activate_span(span)
  # OpenTracing.active_span now equals to span
```

Nested spans:
```elixir
  OpenTracing.start_active_scope("operation1", fn ->
    # Do something

    OpenTracing.start_active_scope("operation2", fn ->
      # Do something else
    end)
  end)
```

### Serializing to the wire

```elixir
  OpenTracing.start_active_scope("operation_name", fn scope ->
    headers = [{"Content-Type", "application/json"}]
    headers = OpenTracing.inject(scope.span.context, :http_headers, headers)
    # headers now include all necessary headers to propagate the span to a remote service
  end)
```

### Deserializing from the wire

An example when using a Plug middleware:

```elixir
  defmodule TraceRequest
    import Plug.Conn

    def init(options), do: options

    def call(%{req_headers: req_headers} = conn, _options) do
      extracted_context = OpenTracing.extract(:http_headers, req_headers)
      scope = OpenTracing.start_active_scope("http-request", %{child_of: extracted_context})

      Plug.Conn.register_before_send(conn, fn conn ->
        scope.close
        conn
      end)
    end
  end
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/opentracing](https://hexdocs.pm/opentracing).

## Licensing

[Apache 2.0 License](./LICENSE).
