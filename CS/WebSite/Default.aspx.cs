using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web.Data;
using DevExpress.Web.ASPxGridView;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.ASPxMenu;

public partial class _Default : Page {
    private bool processAddNewRow;

    protected void Page_Load(object sender, EventArgs e) { }

    protected void grid_DataBound(object sender, EventArgs e) {
        if(!processAddNewRow) {
            grid.FilterExpression = "";
            grid.StartEdit(grid.VisibleStartIndex);
        } else
            processAddNewRow = false;
    }

    protected void grid_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e) {
        if(e.Column.FieldName == "ProductName") {
            e.Editor.SetClientSideEventHandler("Init", "ProductNameEditorInit");
        }
        if(e.Editor is ASPxTextBox) {
            e.Editor.SetClientSideEventHandler("KeyDown", "TextBoxKeyDown");
            e.Editor.SetClientSideEventHandler("KeyUp", "TextBoxKeyUp");
        } else
            e.Editor.SetClientSideEventHandler("ValueChanged", "EditorValueChanged");
    }

    protected void grid_InitNewRow(object sender, ASPxDataInitNewRowEventArgs e) {
        processAddNewRow = true;
        grid.FilterExpression = "false"; // This trick is required to hide all grid rows except for the new row's Edit Form.
        ASPxMenu menu = (ASPxMenu)grid.FindEditFormTemplateControl("editFormMenu");
        menu.Items.FindByName("miNew").ClientEnabled = false;
        menu.Items.FindByName("miDelete").ClientEnabled = false;
        menu.Items.FindByName("miRefresh").ClientEnabled = false;
        menu.Items.FindByName("miUpdate").ClientEnabled = true;
        menu.Items.FindByName("miCancel").ClientEnabled = true;
    }

    protected void ProductsDataSource_Modifying(object sender, SqlDataSourceCommandEventArgs e) {
        throw new Exception("Data modifications are not allowed in this online example.<br>" +
                            "If you need to test the data editing functionality," +
                            "please remove handlers of data modification events from your application's code.");
    }
}
