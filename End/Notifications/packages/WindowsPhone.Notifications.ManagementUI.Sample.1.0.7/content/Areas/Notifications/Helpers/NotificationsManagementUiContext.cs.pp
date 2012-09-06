namespace $rootnamespace$.Areas.Notifications.Helpers
{
    using System;
    using Microsoft.WindowsAzure;

    public class NotificationsManagementUiContext
    {
        private static NotificationsManagementUiContext current;

        public static NotificationsManagementUiContext Current
        {
            get
            {
                if (current == null)
                {
                    current = new NotificationsManagementUiContext();
                    current = Configure(current);

                    if (current == null)
                    {
                        throw new ArgumentNullException("current", "The current context instance cannot be null after configuring it");
                    }

                    if (string.IsNullOrWhiteSpace(current.TileImagesContainerName))
                    {
                        throw new ArgumentException("You must specify a container name", "TileImagesContainerName");
                    }

                    if (!current.TileImagesContainerName.ToLowerInvariant().Equals(current.TileImagesContainerName))
                    {
                        throw new ArgumentException("The container name must be lowercase", "TileImagesContainerName");
                    }

                    if (current.CloudStorageAccount == null)
                    {
                        throw new ArgumentNullException( "CloudStorageAccount", "You must specify a Cloud Storage Account");
                    }
                }

                return current;
            }
        }

        public static Func<NotificationsManagementUiContext, NotificationsManagementUiContext> Configure { get; set; }

        public CloudStorageAccount CloudStorageAccount { get; set; }

        public string TileImagesContainerName { get; set; }
    }
}