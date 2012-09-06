namespace $rootnamespace$.Areas.Notifications.Helpers
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Web.Mvc;
    using System.Web.Mvc.Html;
    using Microsoft.WindowsAzure.StorageClient;
    using $rootnamespace$.Areas.Notifications.ViewModel;

    public static class Extensions
    {
        public static MvcHtmlString MenuItem(this HtmlHelper helper, string linkText, string actionName, string controllerName)
        {
            var li = new TagBuilder("li");
            var routeData = helper.ViewContext.RouteData;
            var currentAction = routeData.GetRequiredString("action");
            var currentController = routeData.GetRequiredString("controller");
            if (string.Equals(currentAction, actionName, StringComparison.OrdinalIgnoreCase) &&
                string.Equals(currentController, controllerName, StringComparison.OrdinalIgnoreCase))
            {
                li.AddCssClass("selected");
            }

            li.InnerHtml = helper.ActionLink(linkText, actionName, controllerName).ToHtmlString();
            return MvcHtmlString.Create(li.ToString());
        }

        public static List<BlobFileInfo> GetAllBlobsInContainer(this CloudBlobClient blobClient, string container)
        {
            var blobContainer = blobClient.GetContainerReference(container);
            var allBlobs = blobContainer.ListBlobs(new BlobRequestOptions() { BlobListingDetails = BlobListingDetails.Metadata });

            var tileImages = new List<BlobFileInfo>();

            foreach (var blob in allBlobs)
            {
                var tileName = Path.GetFileName(blob.Uri.LocalPath);
                tileImages.Add(new BlobFileInfo { FileName = tileName, FileUri = blob.Uri.ToString() });
            }

            return tileImages;
        }
    }
}