defmodule HT16K33 do
  alias ElixirALE.I2C
  require Logger
  
  @moduledoc """
  This module provides a library to controll the Adafruit LED Driver
  via Elixir.
  """
  
  # Default I2C-Address and Registers used to controll the HT16k33.
  @default_i2c_address 0x70
  @default_i2c_devname "i2c-1"
  @ht16k33_blink_cmd 0x80
  @ht16k33_blink_displayon 0x01
  @ht16k33_blink_off 0x00
  @ht16k33_blink_2hz 0x02
  @ht16k33_blink_1hz 0x04
  @ht16k33_blink_halfhz 0x06
  @ht16k33_system_setup 0x20
  @ht16k33_oscivvator 0x01
  @ht16k33_cmd_brightness 0xE0
  
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
        Logger.debug("Connecting to HT16K33 over I2C on #{i2c_address} " +
        "with devname '#{i2c_devname}' succeded.")
        # function_to_call
        {:ok, pid}
      error -> error
    end
  end

end
