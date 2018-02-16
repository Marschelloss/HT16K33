# HT16K33

An Elixir Module to control the LED Backend HT16K33 by Adafruit over I2C. Also
includes Submodules to controll specific Adafruit LEDs like the Seven Segment Display.

This Module was written to be used in a Nerves Project on a RaspberryPi. The
communication over I2C is handled by the module
[ElixirALE](https://hexdocs.pm/elixir_ale/api-reference.html) so this should
work also out of Nerves with ElixirALE compatible Hardware.

Translated from the [Adafruit Python LED Backpack
Library](https://github.com/adafruit/Adafruit_Python_LED_Backpack).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ht16k33` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ht16k33, "~> 0.1.0"}
  ]
end
```

The Documentation can
be found at [https://hexdocs.pm/ht16k33](https://hexdocs.pm/ht16k33).

## Submodules

This Module can be expanded via Submodules to control specific Adafruit Hardware
with the HT16K33-Backend. At the moment only the big (the 1.2"- and not the
0.56"-Version ) Seven Segment Display is supported. 

### 1.2" Seven Segment Display

``` elixir
HT16K33.SevenSegmentBig.start_link() # Using the default Settings: "i2c-1" as
                                     # devname and 0x70 as I2C Adress.

HT16K33.SevenSegmentBig.set_digit("8", 0) # Displays the number 8 on the first position.
```

## Further Development

There are many things which can be inproved:

* Write Submodules for other Adafruit Displays
* Create Module specific Errors
* Some Tests to make this module more stable

