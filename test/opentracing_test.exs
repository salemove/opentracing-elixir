defmodule OpenTracingTest do
  use ExUnit.Case, async: false
  doctest OpenTracing

  setup do
    OpenTracing.Test.Internal.start_link(:test)
    :ok
  end

  describe "#start_active_scope" do
    test "creates nested scopes using block form" do
      OpenTracing.start_active_scope("op1", fn scope1 ->
        assert OpenTracing.active_span == OpenTracing.get_span(scope1)

        OpenTracing.start_active_scope("op2", fn scope2 ->
          assert OpenTracing.active_span == OpenTracing.get_span(scope2)
        end)

        assert OpenTracing.active_span == OpenTracing.get_span(scope1)
      end)

      assert OpenTracing.active_span == nil
    end

    test "creates nested scopes using inline form" do
      scope1 = OpenTracing.start_active_scope("op1")
      assert OpenTracing.active_span == OpenTracing.get_span(scope1)

      scope2 = OpenTracing.start_active_scope("op2")
      assert OpenTracing.active_span == OpenTracing.get_span(scope2)
      OpenTracing.close_scope(scope2)

      assert OpenTracing.active_span == OpenTracing.get_span(scope1)
      OpenTracing.close_scope(scope1)

      assert OpenTracing.active_span == nil
    end
  end

  test "creates and finishes a span explicitly" do
    span = OpenTracing.start_span("operation name")
    assert :ok = OpenTracing.finish_span(span)

    assert [^span] = OpenTracing.Test.Internal.spans
    assert %{finished: true} = OpenTracing.Test.Span.get_state(span)
  end
end
