defmodule HT16K33.SevenSegmentBig do
  alias ElixirALE.I2C

  @moduledoc """
  Module to controll the 'big' 1.2"  Adafruit Seven Segment display
  with HT16K33 Backpack.
  """
  
  # Default adress of the backpack HT16K33.
  @default_i2c_address 0x70
  @default_i2c_devname "i2c-1"
  
  # Define data for given characters in 'normal' state.
  @n_digit_values %{
    " " => 0x00,
    "-" => 0x40,
    "0" => 0x3F,
    "1" => 0x06,
    "2" => 0x5B,
    "3" => 0x4F,
    "4" => 0x66,
    "5" => 0x6D,
    "6" => 0x7D,
    "7" => 0x07,
    "8" => 0x7F,
    "9" => 0x6F,
    "A" => 0x77,
    "B" => 0x7C,
    "C" => 0x39,
    "D" => 0x5E,
    "E" => 0x79,
    "F" => 0x71,
    "L" => 0x38
  }
  
  # Position of each given Segment.
  @pos_segment %{
    0 => 0x00,
    1 => 0x02,
    2 => 0x06,
    3 => 0x08
  }

  @spec start_link(String.t, byte) :: {:ok, pid} | {:error, any}
  def start_link(i2c_devname \\ @default_i2c_devname, 
    i2c_address \\ @default_i2c_address) when is_integer(i2c_address) do
    {_, pid} = HT16K33.start_link(i2c_devname, i2c_address)
    
    HT16K33.clear(pid)
    
    {:ok, pid}
  end
  
  def set_number(pid, pos, val) do
    # TODO: Write if-clauses to catch errors.
    I2C.write(pid, <<@pos_segment[pos], @n_digit_values[val]>>)
  end
  
end
