defmodule Nebulex.Adapters.Local.OptionsTest do
  # Capturing `:stderr` is global, so this module cannot run concurrently.
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  defmodule Cache do
    use Nebulex.Cache,
      otp_app: :nebulex_local,
      adapter: Nebulex.Adapters.Local
  end

  describe ":purge_chunk_size option" do
    test "emits a deprecation warning when given" do
      warning =
        capture_io(:stderr, fn ->
          {:ok, _pid} = Cache.start_link(purge_chunk_size: 10)

          :ok = Cache.stop()
        end)

      assert warning =~ ":purge_chunk_size"
      assert warning =~ "deprecated"
    end

    test "emits nothing when not given" do
      warning =
        capture_io(:stderr, fn ->
          {:ok, _pid} = Cache.start_link()

          :ok = Cache.stop()
        end)

      assert warning == ""
    end

    test "still validates the value type" do
      _ = Process.flag(:trap_exit, true)

      # The deprecation warning fires before the type check; keep it out of
      # the test output.
      capture_io(:stderr, fn ->
        assert {:error, {%NimbleOptions.ValidationError{message: msg}, _}} =
                 Cache.start_link(purge_chunk_size: "invalid")

        assert msg =~ "purge_chunk_size"
      end)
    end
  end
end
