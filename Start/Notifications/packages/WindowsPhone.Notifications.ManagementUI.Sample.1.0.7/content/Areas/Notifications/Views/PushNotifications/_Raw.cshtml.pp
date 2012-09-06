﻿@model $rootnamespace$.Areas.Notifications.ViewModel.MpnsRawViewModel
@using Microsoft.WindowsPhone.Samples.Notifications
@using (
        Ajax.BeginForm(
            "SendRawNotification",
            new AjaxOptions
            {
                OnSuccess = string.Format("UpdateNotificationSatus(data, status, xhr, '{0}_{1}_{2}')", Model.ApplicationId, Model.ClientId, Model.TileId),
                LoadingElementDuration = 1200,
                LoadingElementId = string.Format("sending_{0}_{1}_{2}", Model.ApplicationId, Model.ClientId, Model.TileId),
                HttpMethod = "POST"
            }))
{
    <fieldset>
        @Html.HiddenFor(m => m.ChannelUrl)
        @Html.HiddenFor(m => m.ApplicationId)
        @Html.HiddenFor(m => m.ClientId)
        @Html.HiddenFor(m => m.TileId)
        @Html.HiddenFor(m => m.Priority)

        <div class="editor-label">
            <label>
                Text:</label>
        </div>
        <div class="editor-field">
            @Html.TextBoxFor(m => m.Text)
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
}
