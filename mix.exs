defmodule ScormManifest.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :scorm_manifest,
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end
  
  def application do
    [extra_applications: [:logger]]
  end
  
  defp deps do
    [
      {:sweet_xml, "~> 0.6.5"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
