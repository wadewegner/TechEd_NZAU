[assembly: SilverlightActivator.ApplicationStartupMethodAttribute(typeof($rootnamespace$.App_Start.PushContextBaseInitializer), "PreStart", Order = 10)]

namespace $rootnamespace$.App_Start
{
    using System;
    using System.Windows;
    using Microsoft.Phone.Info;
    using $rootnamespace$.Phone.Notifications;

    public class PushContextBaseInitializer
    {
        public static void PreStart()
        {
            PushContext.Current.Configure(
                c =>
                {
                    // TODO: Update the settings for creating the notification channel for your application.
                    c.ChannelName = Application.Current.Resources["ChannelName"] as string;
                    c.ServiceName = Application.Current.Resources["ServiceName"] as string;

                    // TODO: Update the settings for registering with the Push Notification Registration Service.
                    c.ApplicationId = Application.Current.Resources["ApplicationId"] as string;
					c.DeviceType = Application.Current.Resources["DeviceType"] as string;
                    c.ClientId = DeviceId;

                    // TODO: Update the endpoint of the Push Notification Registration Service.
                    c.EndpointsServiceUri = new Uri(Application.Current.Resources["EndpointsServiceUri"] as string);

                    // TODO: Update the list of allowed domains for getting tile images.
                    c.AllowedDomains.Add(new Uri(Application.Current.Resources["DefaultAllowedDomain"] as string));

                    // TODO: Configure a delegate for signing requests for the Push Notification Registration Service.
                    // - Default value: Anonymous
                    c.SignRequest = r => { };

                    c.Dispatcher = Deployment.Current.Dispatcher;
                });
        }

        public static string DeviceId
        {
            get
            {
                var result = string.Empty;
                object uniqueId;
                if (DeviceExtendedProperties.TryGetValue("DeviceUniqueId", out uniqueId))
                {
                    var deviceUniqueId = (byte[])uniqueId;
                    result = BitConverter.ToString(deviceUniqueId);
                }

                return result;
            }
        }
    }
}
