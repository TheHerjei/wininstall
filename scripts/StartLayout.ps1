(New-Object -Com Shell.Application).
    NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
    Items() |
  %{ $_.Verbs() } |
  ?{$_.Name -match 'Rimuovi da &Start'} |
  %{$_.DoIt()}

Import-StartLayout -LayoutLiteralPath "C:\config\startLayout.xml" -MountLiteralPath "C:\"