defmodule HT16K33.SevenSegmentBig do
  alias ElixirALE.I2C
  use GenServer
  require Logger

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
  
  # Position of each given colon/dot
  @pos_colon %{
    0 => 0x0c,
    1 => 0x03,
    2 => 0x10
  }
  
  # Possible colon/dot states
  @status_colon [:on, :off]
  
  # To check if the given key in some function like `set_digit`
  # are valid, a new module attribute with valid keys get's
  # generated.
  @valid_n_digit_keys Map.keys(@n_digit_values)
  
  @doc """
  Start and link the SevenSegmentBig GenServer.

  `i2c_devname` and `i2c_address` can be defined. Else the default settings
  will be used.

  For more informatins about devname and the adress, take a look at the used 
  module `ElixirALE.I2C` and it's documentation: https://hexdocs.pm/elixir_ale/ElixirALE.I2C.html
  """
  @spec start_link(String.t, byte) :: {:ok, pid}
  def start_link(i2c_devname \\ @default_i2c_devname, 
    i2c_address \\ @default_i2c_address) 
  when is_integer(i2c_address)
  when is_bitstring(i2c_devname) do
    Logger.debug "Started big Seven Segment GenServer..."
    GenServer.start_link __MODULE__, [i2c_devname, i2c_address], name: __MODULE__
  end

  @doc """
  Starts the needed Main-Module HT16K33 GenServer, clears all LEDs and returs
  a state including the pid, which will be used in other functions of this 
  Sub-Module.
  """
  @spec init(list) :: {:ok, %{:pid => pid}}
  def init([i2c_devname, i2c_address]) do
    {_, pid} = HT16K33.start_link(i2c_devname, i2c_address)
    HT16K33.clear(pid)
    
    {:ok, %{:pid => pid}}
  end
  
  def handle_cast({:set_digit, digit, pos}, state) do
    I2C.write(state[:pid], <<@pos_segment[pos], @n_digit_values[digit]>>)
    
    {:noreply, state}
  end
  
  def handle_cast({:set_colon, pos, status}, state) do
    if status == :off do
      I2C.write(state[:pid], <<0x04, 0x00>>)
      
      {:noreply, state}
    else
      I2C.write(state[:pid], <<0x04, @pos_colon[pos]>>)
      
      {:noreply, state}
    end
  end
  
  def handle_cast({:set_raw, register, data}, state) do
    I2C.write(state[:pid], <<register, data>>)

    {:noreply, state}
  end
  
  def handle_info(msg, state) do
    Logger.error "Unknown message: #{msg}"

    {:noreply, state}
  end
  
  @doc """
  Sets a predefined digit at the given position. 

  `digit` can be one of the following values provided as string:
  -, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F, L or a
  'space'-character like " " to clear the position.

  `pos` starts at 0 from left to right till 3.
  """
  @spec set_digit(String.t, 0..3) :: {:ok}
  def set_digit(digit, pos)
  when is_integer(pos) and pos >= 0 and pos <= 3
  when digit in @valid_n_digit_keys do
    GenServer.cast __MODULE__, {:set_digit, digit, pos}
  end
  
  @doc """
  Turns the colon(s) or dot on/off.

  `pos` is the position of the colon/dot from 0 on the left
  to 2 on the right.
  `status` can be either `:on` or `:off`.
  """
  @spec set_colon(0..2, atom) :: {:ok}
  def set_colon(pos, status)
  when is_integer(pos) and pos >= 0 and pos <= 2
  when status in @status_colon do
    GenServer.cast __MODULE__, {:set_colon, pos, status}
  end
 
  @doc """
  Used to write a non-predefined data to the needed register.
  """
  @spec set_raw(byte, byte) :: {:ok}
  def set_raw(register, data) do
    GenServer.cast __MODULE__, {:set_raw, register, data}
  end
  
end
