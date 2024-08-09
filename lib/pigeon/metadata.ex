defmodule Pigeon.Metadata do
  @moduledoc """
  Internal push notification metadata.
  """

  @type t :: %__MODULE__{
          on_response: Pigeon.on_response() | nil,
          notification: map | nil
        }

  @derive {Jason.Encoder, only: []}
  defstruct on_response: nil,
            notification: nil
end
