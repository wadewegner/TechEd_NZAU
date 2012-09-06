namespace $rootnamespace$.Phone.Notifications
{
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Windows.Threading;

    public class PushConfig
    {
        public PushConfig()
        {
            this.AllowedDomains = new List<Uri>();
        }

        public string ChannelName { get; set; }

        public string ServiceName { get; set; }

        public IList<Uri> AllowedDomains { get; private set; }

        public Dispatcher Dispatcher { get; set; }

        public Action<WebRequest> SignRequest { get; set; }

        public Uri EndpointsServiceUri { get; set; }

        public string ApplicationId { get; set; }

        public string ClientId { get; set; }

        public string DeviceType { get; set; }
    }
}
