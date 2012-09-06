[assembly: WebActivator.PreApplicationStartMethod(typeof($rootnamespace$.App_Start.NotificationManagementUi), "PreStart")]

namespace $rootnamespace$.App_Start
{
    using System.Reflection;
    using Microsoft.WindowsAzure;
    using Microsoft.WindowsAzure.StorageClient;
    using $rootnamespace$.Areas.Notifications.Helpers;

    public static class NotificationManagementUi
    {
        public const string TileImagesContainerName = "tileimagescontainer";

        public static void PreStart()
        {
            NotificationsManagementUiContext.Configure = c =>
                {
                    // TODO: Replace with your own Windows Azure Storage account name and key, or read it from a configuration file
                    c.CloudStorageAccount = CloudStorageAccount.DevelopmentStorageAccount;

                    // TODO: Replace with your prefered container name to store tile images
                    c.TileImagesContainerName = TileImagesContainerName;

                    return c;
                };

            UploadTileImage("$rootnamespace$.Resources.WindowsAzureLogo.png");
            UploadTileImage("$rootnamespace$.Resources.WindowsPhoneLogo.png");
            UploadTileImage("$rootnamespace$.Resources.AzureBackground.png");
            UploadTileImage("$rootnamespace$.Resources.DefaultBackground.png");
        }

        private static void UploadTileImage(string imageName)
        {
            var cloudBlobClient = NotificationsManagementUiContext.Current.CloudStorageAccount.CreateCloudBlobClient();
            var tileImagesContainerName = NotificationsManagementUiContext.Current.TileImagesContainerName;

            // Create the container (and make it public)
            var container = cloudBlobClient.GetContainerReference(tileImagesContainerName);
            container.CreateIfNotExist();
            container.SetPermissions(
                new BlobContainerPermissions
                {
                    PublicAccess = BlobContainerPublicAccessType.Blob
                });

            // Upload the image from the assembly resources.
            var assembly = Assembly.GetExecutingAssembly();
            var imageStream = assembly.GetManifestResourceStream(imageName);
            var blob = container.GetBlobReference(imageName.Replace("$rootnamespace$.Resources.", string.Empty));
            blob.Properties.ContentType = "image/png";
            blob.UploadFromStream(imageStream);
        }
    }
}