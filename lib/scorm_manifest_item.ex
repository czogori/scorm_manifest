defmodule ScormManifestItem do
  @moduledoc """
  Documentation for ScormManifestItem.
  """
defstruct [:id,
           :title,
           :type,
           :file,
           :datafromlms,
           :masteryscore,
           :maxtimeallowed,
           :timelimitaction]
end
