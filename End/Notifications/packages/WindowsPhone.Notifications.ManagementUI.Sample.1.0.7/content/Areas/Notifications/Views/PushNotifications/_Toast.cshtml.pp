﻿@model $rootnamespace$.Areas.Notifications.ViewModel.MpnsToastViewModel
@using Microsoft.WindowsPhone.Samples.Notifications

@using (Ajax.BeginForm(
    "SendToastNotification",
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
                Title:</label>
        </div>
        <div class="editor-field">
            @Html.EditorFor(m => m.Title)
        </div>
        <div class="editor-label">
            <label>
                Sub Title:</label>
        </div>
        <div class="editor-field">
            @Html.EditorFor(m => m.SubTitle)
        </div>
        <div class="editor-label">
            <label>
                Target Page:</label>
        </div>
        <div class="editor-field">
            @Html.EditorFor(m => m.TargetPage)
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
