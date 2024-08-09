defmodule Pigeon.Tasks do
  @moduledoc false

  def process_on_response(%{__meta__: %{on_response: nil}}), do: :ok

  def process_on_response(%{__meta__: %{on_response: {m, f}}} = notif) do
    Task.Supervisor.start_child(Pigeon.Tasks, fn ->
      :erlang.apply(m, f, [restore_notification(notif)])
    end)
  end

  def process_on_response(%{__meta__: %{on_response: {m, f, a}}} = notif) do
    Task.Supervisor.start_child(Pigeon.Tasks, fn ->
      :erlang.apply(m, f, [restore_notification(notif)] ++ a)
    end)
  end

  def process_on_response(%{__meta__: %{on_response: fun}} = notif)
      when is_function(fun, 1) do
    Task.Supervisor.start_child(Pigeon.Tasks, fn ->
      fun.(restore_notification(notif))
    end)
  end

  defp restore_notification(%{
         __meta__: %{notification: notification},
         response: :success
       })
       when not is_nil(notification) do
    Pigeon.FCM.Notification
    |> struct(Enum.map(notification, fn {k, v} -> {String.to_atom(k), v} end))
    |> Map.put(:response, success: notification["registration_id"])
  end

  defp restore_notification(
         %{__meta__: %{notification: notification}} = response
       )
       when not is_nil(notification) do
    Pigeon.FCM.Notification
    |> struct(Enum.map(notification, fn {k, v} -> {String.to_atom(k), v} end))
    |> Map.put(:response, response.response)
  end

  defp restore_notification(response), do: response
end
