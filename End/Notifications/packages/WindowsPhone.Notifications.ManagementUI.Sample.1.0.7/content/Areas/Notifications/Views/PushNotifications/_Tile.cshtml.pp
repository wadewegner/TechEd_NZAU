@using Microsoft.WindowsPhone.Samples.Notifications
@model $rootnamespace$.Areas.Notifications.ViewModel.MpnsTileViewModel

@{
    var images = new SelectList(ViewBag.TileImages, "FileUri", "FileName");
}

@using (Ajax.BeginForm(
    "SendTileNotification",
    new AjaxOptions {
        OnSuccess = string.Format("UpdateNotificationSatus(data, status, xhr, '{0}_{1}_{2}')", Model.ApplicationId, Model.ClientId, Model.TileId),
        LoadingElementDuration = 1200, 
        LoadingElementId = string.Format("sending_{0}_{1}_{2}", Model.ApplicationId, Model.ClientId, Model.TileId), 
        HttpMethod = "POST" }))
{
    <fieldset>
        <legend> Front Tile</legend>
        @Html.HiddenFor(m => m.ChannelUrl)
        @Html.HiddenFor(m => m.ApplicationId)
        @Html.HiddenFor(m => m.ClientId)
        @Html.HiddenFor(m => m.TileId)
        @Html.HiddenFor(m => m.Priority)

        <div class="editor-label">
            <label>Title:</label>
        </div>
        <div class="editor-field">
            Clear: @Html.CheckBoxFor(m => m.ClearTitle, new { onchange = "ToggleField(this, '#Title')" })
            @Html.EditorFor(m => m.Title)
        </div>

        <div class="editor-label">
            <label>Count:</label>
        </div>
        <div class="editor-field">
            Clear: @Html.CheckBoxFor(m => m.ClearCount, new { onchange = "ToggleField(this, '#Count')" })
            @Html.EditorFor(m => m.Count)
        </div>

        <div class="editor-label">
            <label>Background Image</label>
        </div>
        <div class="editor-field">
            <div class="imgPreview">
                @Html.DropDownListFor(m => m.BackgroundImageUri, images, new { onchange = "showTileImage(this, '#backgroundImage')" })
                <img id="backgroundImage" src="/Content/images/emptyimage.png" alt="Backgroud Tile Image" />
            </div>
        </div>

        <div class="editor-label">
            <label>
                Notification Priority:</label>
        </div>
        <div class="editor-field">
            @Html.DropDownListFor(m => m.Priority,
                                        Enum.GetNames(typeof(MessageSendPriority)).Select<string, SelectListItem>(p => new SelectListItem() { Text = p, Value = p }))
        </div>
    </fieldset>     

    <fieldset>
        <legend>Back Tile</legend>

        <div class="editor-label">
            <label>Title:</label>
        </div>
        <div class="editor-field">      
            Clear: @Html.CheckBoxFor(m => m.ClearBackTitle, new { onchange = "ToggleField(this, '#BackTitle')" })
            @Html.EditorFor(m => m.BackTitle)
        </div>

        <div class="editor-label">
            <label>Content:</label>
        </div>
        <div class="editor-field">      
            Clear: @Html.CheckBoxFor(m => m.ClearBackContent, new { onchange = "ToggleField(this, '#BackContent')" })
            @Html.EditorFor(m => m.BackContent)
        </div>
        <div class="editor-label">
            <label>Background Image</label>
        </div>
        <div class="editor-field">
            <div class="imgPreview">
                Clear: @Html.CheckBoxFor(m => m.ClearBackBackgroundImageUri, new { onchange = "ToggleField(this, '#BackBackgroundImageUri')" })
                @Html.DropDownListFor(m => m.BackBackgroundImageUri, images, new { onchange = "showTileImage(this, '#backBackgroundImage')" })
                <img id="backBackgroundImage" src="/Content/images/emptyimage.png" alt="Backgroud Tile Image" />
            </div>
        </div>
    </fieldset>
    <script type="text/javascript">
        showTileImage($("#BackgroundImageUri").get(0), '#backgroundImage');
        showTileImage($("#BackBackgroundImageUri").get(0), '#backBackgroundImage');
    </script>
}