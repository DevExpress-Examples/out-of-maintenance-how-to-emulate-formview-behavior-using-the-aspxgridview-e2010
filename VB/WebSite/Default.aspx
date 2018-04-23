<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v10.2" Namespace="DevExpress.Web.ASPxMenu"
    TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxGridView.v10.2" Namespace="DevExpress.Web.ASPxGridView"
    TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v10.2" Namespace="DevExpress.Web.ASPxEditors"
    TagPrefix="dx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>How to emulate FormView behavior using the ASPxGridView</title>

    <script type="text/javascript">
var editorsValues = {};

function ProductNameEditorInit(s, e) {
	s.Focus();
	s.SetCaretPosition(s.GetText().length);
}
function TextBoxKeyDown(s, e) {
	editorsValues[s.name] = s.GetValue();
}
function TextBoxKeyUp(s, e) {
	if(editorsValues[s.name] != s.GetValue())
		StartEdit();
}
function EditorValueChanged(s, e) {
	StartEdit();
}
function StartEdit() {
	editFormMenu.GetItemByName("miUpdate").SetEnabled(true);
	editFormMenu.GetItemByName("miCancel").SetEnabled(true);
}
function OnMenuItemClick(s, e) {
	switch(e.item.name) {
		case "miUpdate": grid.UpdateEdit(); break;
		case "miNew": grid.AddNewRow(); break;
		case "miDelete":
			if(confirm('Are you sure to delete this record?'))
				grid.DeleteRow(grid.GetTopVisibleIndex());
			break;
		case "miRefresh":
		case "miCancel": grid.Refresh(); break;                                                    
	}
}
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxGridView ID="grid" runat="server" AutoGenerateColumns="False" DataSourceID="ProductsDataSource"
                KeyFieldName="ProductID" Width="450px" OnDataBound="grid_DataBound" OnCellEditorInitialize="grid_CellEditorInitialize"
                OnInitNewRow="grid_InitNewRow">
                <SettingsPager PageSize="1" />
                <SettingsEditing EditFormColumnCount="1" Mode="EditForm" NewItemRowPosition="Bottom" />
                <Settings ShowTitlePanel="True" ShowColumnHeaders="False" />
                <SettingsText Title="Products" />
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="ProductName" VisibleIndex="0" />
                    <dx:GridViewDataComboBoxColumn FieldName="CategoryID" VisibleIndex="1" Caption="Category">
                        <PropertiesComboBox DataSourceID="CategoriesDataSource" ValueType="System.Int32"
                            TextField="CategoryName" ValueField="CategoryID" />
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataSpinEditColumn FieldName="UnitPrice" VisibleIndex="2">
                        <PropertiesSpinEdit DisplayFormatString="c" NumberFormat="Currency" />
                    </dx:GridViewDataSpinEditColumn>
                    <dx:GridViewDataTextColumn FieldName="QuantityPerUnit" VisibleIndex="3" />
                    <dx:GridViewDataSpinEditColumn FieldName="UnitsInStock" VisibleIndex="4">
                        <PropertiesSpinEdit DisplayFormatString="g" NumberFormat="Custom" />
                    </dx:GridViewDataSpinEditColumn>
                    <dx:GridViewDataSpinEditColumn FieldName="UnitsOnOrder" VisibleIndex="5">
                        <PropertiesSpinEdit DisplayFormatString="g" NumberFormat="Custom" />
                    </dx:GridViewDataSpinEditColumn>
                    <dx:GridViewDataCheckColumn FieldName="Discontinued" VisibleIndex="6" />
                    <dx:GridViewDataTextColumn FieldName="ProductID" ReadOnly="True" VisibleIndex="7"
                        Visible="False" />
                </Columns>
                <Templates>
                    <EditForm>
                        <dx:ASPxMenu ID="editFormMenu" runat="server" ClientInstanceName="editFormMenu" Width="100%"
                            AutoPostBack="false" EnableHotTrack="true" EnableClientSideAPI="True" ItemAutoWidth="False">
                            <Items>
                                <dx:MenuItem Text="New" Name="miNew" />
                                <dx:MenuItem Text="Delete" Name="miDelete" />
                                <dx:MenuItem Text="Refresh" Name="miRefresh" />
                                <dx:MenuItem Text="Update" Name="miUpdate" ClientEnabled="false" BeginGroup="true" />
                                <dx:MenuItem Text="Cancel" Name="miCancel" ClientEnabled="false" />
                            </Items>
                            <ClientSideEvents ItemClick="OnMenuItemClick" />
                        </dx:ASPxMenu>
                        <div style="margin-top: 5px;">
                            <dx:ASPxGridViewTemplateReplacement runat="server" ID="Editors" ReplacementType="EditFormEditors" />
                        </div>
                    </EditForm>
                </Templates>
            </dx:ASPxGridView>
        </div>
        <asp:AccessDataSource ID="ProductsDataSource" runat="server" DataFile="~/App_Data/nwind.mdb"
            SelectCommand="SELECT [ProductID], [ProductName], [CategoryID], [QuantityPerUnit], [UnitPrice],
								  [UnitsInStock], [UnitsOnOrder], [Discontinued] FROM [Products]"
            UpdateCommand="UPDATE [Products] SET [ProductName] = ?, [CategoryID] = ?, [QuantityPerUnit] = ?,
								  [UnitPrice] = ?, [UnitsInStock] = ?, [UnitsOnOrder] = ?, [Discontinued] = ? WHERE [ProductID] = ?"
            DeleteCommand="DELETE FROM [Products] WHERE [ProductID] = ?" InsertCommand="INSERT INTO [Products] ([ProductName], [CategoryID], [QuantityPerUnit], [UnitPrice],
									   [UnitsInStock], [UnitsOnOrder], [Discontinued]) VALUES (?, ?, ?, ?, ?, ?, ?)"
            OnDeleting="ProductsDataSource_Modifying" OnInserting="ProductsDataSource_Modifying"
            OnUpdating="ProductsDataSource_Modifying">
            <UpdateParameters>
                <asp:Parameter Name="ProductName" Type="String" />
                <asp:Parameter Name="CategoryID" Type="Int32" />
                <asp:Parameter Name="QuantityPerUnit" Type="String" />
                <asp:Parameter Name="UnitPrice" Type="Decimal" />
                <asp:Parameter Name="UnitsInStock" Type="Int16" />
                <asp:Parameter Name="UnitsOnOrder" Type="Int16" />
                <asp:Parameter Name="Discontinued" Type="Boolean" />
                <asp:Parameter Name="ProductID" Type="Int32" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="ProductID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="ProductName" Type="String" />
                <asp:Parameter Name="CategoryID" Type="Int32" />
                <asp:Parameter Name="QuantityPerUnit" Type="String" />
                <asp:Parameter Name="UnitPrice" Type="Decimal" />
                <asp:Parameter Name="UnitsInStock" Type="Int16" />
                <asp:Parameter Name="UnitsOnOrder" Type="Int16" />
                <asp:Parameter Name="Discontinued" Type="Boolean" />
            </InsertParameters>
        </asp:AccessDataSource>
        <asp:AccessDataSource ID="CategoriesDataSource" runat="server" DataFile="~/App_Data/nwind.mdb"
            SelectCommand="SELECT [CategoryID], [CategoryName] FROM [Categories]" />
    </form>
</body>
</html>
