defmodule HT16K33Test do
  use ExUnit.Case
  doctest HT16K33
  
  test "Return integer in hex-style with prefix" do
    assert HT16K33.integer_to_hex_string(112) == "0x70"
  end
end
