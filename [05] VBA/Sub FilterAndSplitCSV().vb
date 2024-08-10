Sub FilterAndSplitCSV()
    On Error GoTo ErrorHandler
    
    Dim wsData As Worksheet
    Dim lastRow As Long
    Dim lastCol As Long
    Dim headerRow As Long
    Dim groupCol As Long
    Dim groupArray As Variant
    Dim i As Long
    Dim folderPath As String
    
    ' Set the worksheet with the data
    Set wsData = ActiveSheet
    
    ' Find the last row and column of data
    lastRow = wsData.Cells(wsData.Rows.Count, "A").End(xlUp).Row
    lastCol = wsData.Cells(1, wsData.Columns.Count).End(xlToLeft).Column
    
    ' Set the header row
    headerRow = 8 ' Assuming headers are in row 8
    
    ' Find the column with the "Group" data
    Set rngHeader = wsData.Rows(headerRow)
    groupCol = rngHeader.Find("Invite Custom Field 2").Column
    
    If groupCol = 0 Then
        MsgBox "The 'Invite Custom Field 2' header was not found.", vbExclamation
        Exit Sub
    End If
    
    ' Create a folder with the current date
    folderPath = ThisWorkbook.Path & "\" & Format(Date, "yyyy-mm-dd")
    If Dir(folderPath, vbDirectory) = "" Then MkDir folderPath
    
    ' Array to store the group names
    groupArray = Array("TPT", "TPM", "TPR", "TPG")
    
    ' Loop through each group
    For i = LBound(groupArray) To UBound(groupArray)
        ' Copy the data to a new workbook
        wsData.Copy
        With ActiveWorkbook.Sheets(1)
            .Name = "Filtered Data"
            
            ' Filter the data based on the current group
            .Range("A" & headerRow & ":XFD" & lastRow).AutoFilter Field:=groupCol, Criteria1:="=*" & groupArray(i) & "*"
            
            ' Delete the rows that don't match the filter
            On Error Resume Next ' Ignore errors if no visible rows are found
            .Range("A" & headerRow + 1 & ":XFD" & lastRow).SpecialCells(xlCellTypeVisible).Offset(1).Resize(lastRow - headerRow - 1).Rows.Delete
            On Error GoTo ErrorHandler ' Re-enable error handling
            
            ' Turn off the filter
            .AutoFilterMode = False
        End With
        
        ' Save the new workbook in the folder with the current date
        ActiveWorkbook.SaveAs Filename:=folderPath & "\" & "PNPS " & groupArray(i) & " " & Format(Date, "yyyy-mm-dd") & ".csv", FileFormat:=xlCSV
        
        ' Close the new workbook
        ActiveWorkbook.Close
    Next i
    
    MsgBox "Filtering and splitting completed successfully. Files saved in " & folderPath, vbInformation
    
    Exit Sub
    
ErrorHandler:
    MsgBox "An error occurred: " & Err.Description, vbExclamation
    ActiveWorkbook.Close savechanges:=False ' Close the new workbook without saving
End Sub