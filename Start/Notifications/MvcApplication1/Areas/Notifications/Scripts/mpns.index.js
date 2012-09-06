function selectorEscape(text) {
    return text.replace(/[!"#$%&'()*+,./:;<=>?@@[\]^`{|}~|#\s]/g, "\\$&");
}

function showTileImage(selection, imageId) {
    var uri = selection.options[selection.selectedIndex].value;
    if (!uri) {
        uri = "/Areas/Notifications/Content/images/emptyimage.png";
    }        
    $(imageId).attr("src", uri);
}

function UpdateNotificationSatus(data, status, xhr, id) {
    $("[id='sending_" + id + "']").html();

    if (data.DeviceConnectionStatus) {
        $("[id='DeviceConnectionStatus_" + id + "']").html(data.DeviceConnectionStatus);
    }

    if (data.NotificationStatus) {
        $("[id='NotificationStatus_" + id + "']").html(data.NotificationStatus);
    }
    
    setTimeout(function () {
        $("[id='result_" + id + "']").html(data.Status);
    }, 500);
    
    setTimeout("clearResultMessages('" + "result_" + id + "')", 6000);
}

function clearNotificationsForm() {
    $('#notificationTemplate').empty();
    $('#notificationType').val(0);
}

function clearResultMessages(id) {
    $("[id='" + id + "']").fadeOut('slow', function() { $(this).html('&nbsp;').show(); });
}

$(document).ready(function () {
    $('.createNotification').click(function() {
        var id = $(this).attr('id');
        var tmpId = id.replace(/\|/g, '_');
        var url = $("[id='url_" + tmpId + "']").text();

        $('#itemIdentifier').val(id);
        $('#itemUrl').val(url);

        clearNotificationsForm();
        
        $("#templateWindow").dialog({
            height: 515,
            width: 560,
            modal: true,
            title: 'Push Notification',
            resizable: false,
            buttons: [{
                text: 'Send',
                style: 'display:none;',
                click: function() {
                    $('form').submit();
                    $(this).dialog("close");
                }},
                { text: 'Cancel',  click: function() { $(this).dialog("close"); } }
               ]
        });
    });
    
    $('.notificationType').change(function () {
        var notificationType = $(this).val();
        
        $('#notificationTemplate').empty();
        $('.ui-dialog-buttonset button:first').hide();
        
        if (notificationType <= 0)
            return;
        
        $('#notificationTemplate').text('loading...');
        
        // find applicationId and deviceId
        var ids = $('#itemIdentifier').val().split('|');
        var appId = ids[0];
        var clientId = ids[1];
        var tileId = ids[2];

        // find previous select element value
        var url = $('#itemUrl').val();

        var data = {
            NotificationType: notificationType,
            ApplicationId: appId,
            ClientId: clientId,
            TileId: tileId,
            Url: jQuery.trim(url)
        };
                   
        $.ajax({
            type: 'POST',
            url: '/Notifications/PushNotifications/GetSendTemplate',
            data: data,
            dataType: 'html',
            success: function (result) {
                $('.ui-dialog-buttonset button:first').show();                
                $('#notificationTemplate').html(result);
            }
        });
    });
});

function ToggleField(checkBox, fieldId) {
    if (checkBox.checked) {
        $(fieldId).val();
        $(fieldId).attr('disabled', true);
    } else {
        $(fieldId).attr('disabled', false);
    }
    return true;
}