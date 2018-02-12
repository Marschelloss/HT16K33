defmodule HT16K33 do
  alias ElixirALE.I2C
  require Logger
  require Bitwise
  
  @moduledoc """
  This module provides a library to controll the Adafruit LED Driver
  via Elixir.
  """
  
  # Default I2C-Address and Registers used to controll the HT16k33.
  @default_i2c_address 0x70
  @default_i2c_devname "i2c-1"
  @ht16k33_blink_cmd 0x80
  @ht16k33_blink_displayon 0x01
  @ht16k33_system_setup 0x20
  @ht16k33_oscillator 0x01
  @ht16k33_cmd_brightness 0xE0
  
  @ht16k33_blink_list %{
    "blink_off" => 0x00,
    "blink_2hz" => 0x02,
    "blink_1hz" => 0x04,
    "blink_halfhz" => 0x06
  }
  
  @doc """
  Starting the ElixirALE.I2C GenServer to write and read over I2C. 
  Uses default I2C Address and DevName to access the HT16K33.
  """
  @spec start_link(String.t, byte) :: {:ok, pid} | {:error, any}
  def start_link(i2c_devname \\ @default_i2c_devname, 
    i2c_address \\ @default_i2c_address) when is_integer(i2c_address) do
    case I2C.start_link(i2c_devname, i2c_address) do
      {:ok, pid} ->
        # TODO: Maybe check some kind of id to prove if a HT16K33 was found?
        Logger.debug("Connecting to HT16K33 over I2C on address " <>
          integer_to_hex_string(i2c_address) <> " with devname '#{i2c_devname}' succeded.")
        # function_to_call
        {:ok, pid}
      error -> error
    end
  end
  
  @doc """
  Initialize the HT16K33 via turning on the oscillator, the display
  and setting it to 'no blinking' and also to full brightness.
  """
  @spec run_init(pid) :: :ok
  def run_init(pid) when is_pid(pid) do
    # Turn on oscillator.
    I2C.write(pid, <<Bitwise.bor(@ht16k33_system_setup, @ht16k33_oscillator)>>)
    # Turn display on with no blinking.
    set_blink(pid, "blink_off")
  end
  
  @doc """
  Sets Blink frequency of the display. Needs a predefined variable as freq.
  Valid frequencies are: "blink_off", "blink_2hz", "blink_1hz and "blink_halfhz".

  Example: `HT16K33.set_blink(pid, "blink_off")`
  """
  def set_blink(pid, freq_key) when is_pid(pid) do
    if Map.has_key?(@ht16k33_blink_list, freq_key) do
      data = 
        Bitwise.bor(@ht16k33_blink_cmd, @ht16k33_blink_displayon)
        |> Bitwise.bor(@ht16k33_blink_list[freq_key])

      I2C.write(pid, <<data>>)
      {:ok}
    else
      # TODO: Define Error "freq was not found in blink_list"
      {:error}
    end
  end
  
  @doc """
  Simple function which returns a integer in hex as string with "0x"-prefix
  to provide clearer output in functions.
  """
  def integer_to_hex_string(int), do: "0x" <> Integer.to_string(int, 16)

end
