defmodule ScormManifestTest do
  use ExUnit.Case
  doctest ScormManifest

  @manifest ~S"""
<?xml version="1.0" standalone="no"?>
<manifest 
  identifier="TestManifest" 
  version="0.99" 
  xmlns="http://www.imsproject.org/xsd/imscp_rootv1p1p2" 
  xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xsi:schemaLocation="http://www.imsproject.org/xsd/imscp_rootv1p1p2 
  imscp_rootv1p1p2.xsd http://www.imsglobal.org/xsd/imsmd_rootv1p2p1 
  imsmd_rootv1p2p1.xsd http://www.adlnet.org/xsd/adlcp_rootv1p2 adlcp_rootv1p2.xsd">
  <metadata>
      <schema>ADL SCORM</schema>
      <schemaversion>1.2</schemaversion>
      <adlcp:location>packagemetadata.xml</adlcp:location>
  </metadata>
  <organizations default="ORG1">
    <organization identifier="ORG1">
      <title>Test manifest</title>
      <item identifier="ITEM1" identifierref="SCO1">
        <title>First SCO</title>
        <adlcp:maxtimeallowed>0000:50:00</adlcp:maxtimeallowed>
				<adlcp:datafromlms>Data from LMS</adlcp:datafromlms>
				<adlcp:masteryscore>80</adlcp:masteryscore>
				<adlcp:timelimitaction>exit,message</adlcp:timelimitaction>
      </item>
      <item identifier="ITEM2" identifierref="SCO2">
        <title>Second SCO</title>
      </item>
    </organization>
  </organizations>
  <resources>
    <resource identifier="SCO1" adlcp:scormtype="sco"
        href="index.htm" type="webcontent">
      <file href="index.htm"/>
    </resource>
    <resource identifier="SCO2" adlcp:scormtype="sco"
        href="index2.htm" type="webcontent">
      <file href="index2.htm"/>
    </resource>
  </resources>
</manifest>
"""

  test "info multi sco" do
    expected_map = %{
      version: '1.2',
      title: 'Test manifest',
      items: [
        %{
          id: 'ITEM1',
          title: 'First SCO',
          type: 'sco',
          file: 'index.htm',
          datafromlms: 'Data from LMS',
          masteryscore: '80',
          maxtimeallowed: '0000:50:00',
          timelimitaction: 'exit,message'
        },
        %{
          id: 'ITEM2',
          title: 'Second SCO',
          type: 'sco',
          file: 'index2.htm',
          datafromlms: nil,
          masteryscore: nil,
          maxtimeallowed: nil,
          timelimitaction: nil
        },
      ]
    }
    assert {:ok, expected_map} == ScormManifest.parse(@manifest)
  end

  test "Try pass empty string" do
    assert {:error, "Empty string"} == ScormManifest.parse("")
  end

  test "Try pass not string" do
    assert {:error, "Only string is correct format"} == ScormManifest.parse(1)
    assert {:error, "Only string is correct format"} == ScormManifest.parse([])
  end
end
