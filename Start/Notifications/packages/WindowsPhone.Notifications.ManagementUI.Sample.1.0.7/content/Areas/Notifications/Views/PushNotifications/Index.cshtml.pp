﻿@model IEnumerable<Endpoint>

@using $rootnamespace$.CloudServices.Notifications

@{
    ViewBag.Title = "Push Notifications";
}

<script src="@Url.Content("/Areas/Notifications/Scripts/mpns.index.js")" type="text/javascript"></script> 

<h2>Push Notifications</h2>
<p>You can use this page to generate and send push notifications to your registered Windows Phone applications</p>

<table class="left-aligned">
    <tr>
        <th>
            UserID
        </th>
        <th>  
            ApplicationID
        </th>
        <th>
            ClientID
        </th>
        <th>  
            TileID
        </th>
        <th>
            Channel
        </th>
        <th>
            Actions
        </th>
    </tr>
    @{
    var i = 0;
    foreach (var item in Model)
    {
        <tr class="d@(i%2)">
            <td>
                @string.Format("{0}", (string.IsNullOrEmpty(item.UserId)) ? "Anonymous" : item.UserId)
            </td>         
            <td>               
                @Html.DisplayFor(modelItem => item.ApplicationId)
            </td>
            <td>
                @Html.DisplayFor(modelItem => item.ClientId)
            </td>
            <td>
                @Html.DisplayFor(modelItem => item.TileId)
            </td>         
            <td class="PushNotificationChannelUrl">
                <div><strong>Device Connection Status:</strong> <div id="DeviceConnectionStatus_@(item.ApplicationId)_@(item.ClientId)_@(item.TileId)"></div> </div>
                <div><strong>Notification Status:</strong><div id="NotificationStatus_@(item.ApplicationId)_@(item.ClientId)_@(item.TileId)"></div> </div>

                <a class="expand-link-button" onclick="$(this).toggleClass('minus').next().toggleClass('short-url');">&nbsp;</a>
                <div id="url_@(item.ApplicationId)_@(item.ClientId)_@(item.TileId)" class="channel-url short-url">@Html.DisplayFor(modelItem => item.ChannelUri)</div>
            </td>
            <td class="PushNotificationTextColumn">
                <input type="button" value="Send Notification" id="@(item.ApplicationId)|@(item.ClientId)|@(item.TileId)" class="createNotification" /><br/>
                <img class="sending hidden" id="@string.Format("sending_{0}_{1}_{2}", item.ApplicationId, item.ClientId, item.TileId)" src="@Url.Content("~/Areas/Notifications/Content/images/sending.gif")" alt="Sending push notification" />
                <span id="@string.Format("result_{0}_{1}_{2}", item.ApplicationId, item.ClientId, item.TileId)" class="result">&nbsp;</span>     
            </td>
        </tr>   
        i++; 
        }
    }
</table>

<div id="templateWindow" class="ui-widget" style="display: none;">
    <p>Select the notification type and template:</p>
    @Html.Label("notificationType", "Notification Type:")
    @Html.DropDownList("notificationType",
                                            new List<SelectListItem>
                                            {
                                                    new SelectListItem {Text="--- Select Value ---", Value ="0"},
                                                    new SelectListItem {Text="Raw", Value ="Raw"},
                                                    new SelectListItem {Text="Tile", Value ="Tile"},
                                                    new SelectListItem {Text="Toast", Value ="Toast"}
                                            }, new { @class = "notificationType" })
    
    @Html.Hidden("itemIdentifier")
    @Html.Hidden("itemUrl")
    <div id="notificationTemplate"></div>
</div>