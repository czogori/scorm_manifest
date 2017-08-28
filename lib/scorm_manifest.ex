defmodule ScormManifest do
  import SweetXml
  @moduledoc """
  Documentation for ScormManifest.
  """
  def parse(""), do: {:error, "Empty string"}
  def parse(xml) when is_bitstring(xml) do
    r = raw(xml)
    default_organization = default_organization(r)

    map = %{
      version: r.schemaversion,
      title: default_organization.title,
      items: parse_items(default_organization.items, r.resources)
    }
    {:ok, map}
  end
  def parse(_), do: {:error, "Only string is correct format"}

  defp raw(xml) do
    xml
    |> xmap(
      schema: ~x"//metadata/schema/text()",
      schemaversion: ~x"//metadata/schemaversion/text()",
      default_organization: ~x"//organizations/@default",
      organizations: [
        ~x"//organizations/organization"l,
        identifier: ~x"./@identifier",
        title: ~x"./title/text()",
        items: [
          ~x"./item"l,
          title: ~x"./title/text()",
          identifier: ~x"./@identifier",
          identifierref: ~x"./@identifierref",
          datafromlms: ~x"./adlcp:datafromlms/text()",
          masteryscore: ~x"./adlcp:masteryscore/text()",
          maxtimeallowed: ~x"./adlcp:maxtimeallowed/text()",
          timelimitaction: ~x"./adlcp:timelimitaction/text()"
        ]
      ],
      resources: [
        ~x"//resources/resource"l,
        identifier: ~x"./@identifier",
        scormtype: ~x"./@adlcp:scormtype",
        href: ~x"./@href",
        type: ~x"./@type",
        files: ~x"./file/@href"l,
      ]
    )
  end

  defp default_organization(raw) do
    [org] = Enum.filter(raw.organizations,
      fn n -> n.identifier == raw.default_organization end)
    org
  end

  defp parse_items([], _), do: []
  defp parse_items([h | t], r) do
    [Map.merge(
      %{
        id: h.identifier,
        title: h.title,
        datafromlms: h.datafromlms,
        masteryscore: h.masteryscore,
        maxtimeallowed: h.maxtimeallowed,
        timelimitaction: h.timelimitaction
      }, parse_resource(r, h.identifierref)) | parse_items(t, r)]
  end

  defp parse_resource(r, id) do
    [res] = Enum.filter(r, fn n -> n.identifier == id end)
    %{file: res.href, type: res.scormtype}
  end
end
