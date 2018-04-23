Imports Microsoft.VisualBasic
Imports System
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports DevExpress.Web.Data
Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxMenu

Partial Public Class _Default
	Inherits Page
	Private processAddNewRow As Boolean

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
	End Sub

	Protected Sub grid_DataBound(ByVal sender As Object, ByVal e As EventArgs)
		If (Not processAddNewRow) Then
			grid.FilterExpression = ""
			grid.StartEdit(grid.VisibleStartIndex)
		Else
			processAddNewRow = False
		End If
	End Sub

	Protected Sub grid_CellEditorInitialize(ByVal sender As Object, ByVal e As ASPxGridViewEditorEventArgs)
		If e.Column.FieldName = "ProductName" Then
			e.Editor.SetClientSideEventHandler("Init", "ProductNameEditorInit")
		End If
		If TypeOf e.Editor Is ASPxTextBox Then
			e.Editor.SetClientSideEventHandler("KeyDown", "TextBoxKeyDown")
			e.Editor.SetClientSideEventHandler("KeyUp", "TextBoxKeyUp")
		Else
			e.Editor.SetClientSideEventHandler("ValueChanged", "EditorValueChanged")
		End If
	End Sub

	Protected Sub grid_InitNewRow(ByVal sender As Object, ByVal e As ASPxDataInitNewRowEventArgs)
		processAddNewRow = True
		grid.FilterExpression = "false" ' This trick is required to hide all grid rows except for the new row's Edit Form.
		Dim menu As ASPxMenu = CType(grid.FindEditFormTemplateControl("editFormMenu"), ASPxMenu)
		menu.Items.FindByName("miNew").ClientEnabled = False
		menu.Items.FindByName("miDelete").ClientEnabled = False
		menu.Items.FindByName("miRefresh").ClientEnabled = False
		menu.Items.FindByName("miUpdate").ClientEnabled = True
		menu.Items.FindByName("miCancel").ClientEnabled = True
	End Sub

	Protected Sub ProductsDataSource_Modifying(ByVal sender As Object, ByVal e As SqlDataSourceCommandEventArgs)
		Throw New Exception("Data modifications are not allowed in this online example.<br>" & "If you need to test the data editing functionality," & "please remove handlers of data modification events from your application's code.")
	End Sub
End Class
