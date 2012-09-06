namespace $rootnamespace$.Areas.Notifications.ViewModel
{
    using System;
    using Microsoft.WindowsPhone.Samples.Notifications;

    public abstract class MpnsBaseViewModel
    {
        public string ChannelUrl { get; set; }

        public string ApplicationId { get; set; }

        public string ClientId { get; set; }

        public string TileId { get; set; }

        public MessageSendPriority Priority { get; set; }
    }
}