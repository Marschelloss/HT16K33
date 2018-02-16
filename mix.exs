defmodule HT16K33.MixProject do
  use Mix.Project

  def project do
    [
      app: :ht16k33,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      name: "HT16K33",
      source_url: "https://github.com/DonHansDampf/HT16K33"
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_ale, "~> 1.0"}
    ]
  end
  
  defp description() do
    "Module to control the LED-Backpack HT16K33 by Adafruit over I2C. Including " <>
    "Submodules to controll specific Adafruit LEDs lik the Seven Segment Display."
  end
  
  defp package() do
    [
      licenses: ["MIT License"],
      maintainers: ["Marcel Keßler"],
      links: %{"GitHub" => "https://github.com/DonHansDampf/HT16K33"}
    ]
  end
end
