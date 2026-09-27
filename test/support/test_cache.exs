defmodule Nebulex.Adapters.Local.TestCache do
  @moduledoc false
  use Nebulex.Cache,
    otp_app: :nebulex_local,
    adapter: Nebulex.Adapters.Local

  def get_and_update_fun(nil), do: {nil, 1}
  def get_and_update_fun(current) when is_integer(current), do: {current, current * 2}

  def get_and_update_bad_fun(_), do: :other

  def fetch_or_store_fun, do: {:ok, "value"}

  def fetch_or_store_error_fun, do: {:error, :error}

  def get_or_store_fun, do: "value"
end
