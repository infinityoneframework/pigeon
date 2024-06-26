defmodule Pigeon.Tasks do
  @moduledoc false

  def process_on_response(%{__meta__: %{on_response: nil}}), do: :ok

  def process_on_response(%{__meta__: %{on_response: {m, f}}} = notif) do
    Task.Supervisor.start_child(Pigeon.Tasks, fn ->
      :erlang.apply(m, f, [Map.delete(notif, :__meta__)])
    end)
  end

  def process_on_response(%{__meta__: %{on_response: {m, f, a}}} = notif) do
    Task.Supervisor.start_child(Pigeon.Tasks, fn ->
      :erlang.apply(m, f, [Map.delete(notif, :__meta__)] ++ a)
    end)
  end

  def process_on_response(%{__meta__: %{on_response: fun}} = notif)
      when is_function(fun, 1) do
    Task.Supervisor.start_child(Pigeon.Tasks, fn ->
      fun.(Map.delete(notif, :__meta__))
    end)
  end
end
