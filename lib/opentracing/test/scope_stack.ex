defmodule OpenTracing.Test.ScopeStack do
  @key :scope_stack

  def add(scope) do
    scopes = Process.get(@key, [])
    Process.put(@key, [scope | scopes])
  end

  def peek do
    Enum.at(Process.get(@key, []), 0)
  end

  def pop do
    scopes = Process.get(@key, [])
    if length(scopes) > 0 do
      [_ | remaining_scopes] = scopes
      Process.put(@key, remaining_scopes)
    end
  end
end
