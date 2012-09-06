namespace MvcApplication1.Areas.Notifications.Controllers
{
    using System;
    using System.Linq;
    using System.Text;
    using System.Web.Mvc;
    using Microsoft.WindowsAzure.StorageClient;
    using Microsoft.WindowsPhone.Samples.Notifications;
    using MvcApplication1.Areas.Notifications.Helpers;
    using MvcApplication1.Areas.Notifications.ViewModel;
	using MvcApplication1.CloudServices.Notifications;

    // Uncomment the following line of code to secure your Management UI.
    // [Authorize]
    public class PushNotificationsController : Controller
    {
        private readonly IEndpointRepository endpointRepository;
        private readonly CloudBlobClient cloudBlobClient;
        private readonly string tileImagesContainerName;

        public PushNotificationsController()
            : this(NotificationServiceContext.Current.Configuration.StorageProvider, NotificationsManagementUiContext.Current.CloudStorageAccount.CreateCloudBlobClient(), NotificationsManagementUiContext.Current.TileImagesContainerName)
        {
        }

        public PushNotificationsController(IEndpointRepository endpointRepository, CloudBlobClient cloudBlobClient, string tileImagesContainerName)
        {
            if (cloudBlobClient == null)
            {
                throw new ArgumentNullException("cloudBlobClient", "The Cloud Blob Client cannot be null");
            }

            if (endpointRepository == null)
            {
                throw new ArgumentNullException("endpointRepository", "The Endpoints repository cannot be null");
            }

            if (string.IsNullOrWhiteSpace(tileImagesContainerName))
            {
                throw new ArgumentException("The container name for the tile images cannot be null, empty or white space", "tileImagesContainerName");
            }

            this.cloudBlobClient = cloudBlobClient;
            this.endpointRepository = endpointRepository;
            this.tileImagesContainerName = tileImagesContainerName;
        }

        public ActionResult Index()
        {
            return View(this.endpointRepository.All());
        }

        [HttpPost]
        public ActionResult SendRawNotification(MpnsRawViewModel vm)
        {
            if (string.IsNullOrEmpty(vm.Text))
            {
                object error = new { Status = "Error sending notification: Field Text cannot be empty" };
                return this.Json(error);
            }

            if (!this.EndpointExists(vm.ApplicationId, vm.TileId, vm.ClientId, vm.ChannelUrl))
            {
                object error = new { Status = "Error sending notification: Endpoint does not exist" };
                return this.Json(error);
            }

            try
            {
                var notification = new RawPushNotificationMessage { RawData = Encoding.UTF8.GetBytes(vm.Text), SendPriority = vm.Priority };

                var result = notification.Send(new Uri(vm.ChannelUrl));

                object response =
                    new
                        {
                            SubscriptionStatus = result.SubscriptionStatus.ToString(),
                            DeviceConnectionStatus = result.DeviceConnectionStatus.ToString(),
                            NotificationStatus = result.NotificationStatus.ToString(),
                            Status = result.LookupDeliveryStatus()
                        };

                return this.Json(response);
            }
            catch (ArgumentOutOfRangeException exception)
            {
                object error = new { Status = exception.Message };
                return this.Json(error);
            }
            catch (InvalidOperationException exception)
            {
                object error = new { Status = exception.Message };
                return this.Json(error);
            }
        }

        [HttpPost]
        public ActionResult SendToastNotification(MpnsToastViewModel vm)
        {
            if (string.IsNullOrEmpty(vm.Title))
            {
                object error = new { Status = "Error sending notification: Field Title cannot be empty" };
                return this.Json(error);
            }

            if (!this.EndpointExists(vm.ApplicationId, vm.TileId, vm.ClientId, vm.ChannelUrl))
            {
                object error = new { Status = "Error sending notification: Endpoint does not exist" };
                return this.Json(error);
            }

            this.Escape(vm.Title);
            this.Escape(vm.SubTitle);

            try
            {
                var notification = new ToastPushNotificationMessage()
                    {
                        Title = this.Escape(vm.Title),
                        Subtitle = this.Escape(vm.SubTitle),
                        TargetPage = vm.TargetPage,
                        SendPriority = vm.Priority
                    };

                var result = notification.Send(new Uri(vm.ChannelUrl));

                object response =
                    new
                        {
                            SubscriptionStatus = result.SubscriptionStatus.ToString(),
                            DeviceConnectionStatus = result.DeviceConnectionStatus.ToString(),
                            NotificationStatus = result.NotificationStatus.ToString(),
                            Status = result.LookupDeliveryStatus()
                        };

                return this.Json(response);
            }
            catch (ArgumentOutOfRangeException exception)
            {
                object error = new { Status = exception.Message };
                return this.Json(error);
            }
            catch (InvalidOperationException exception)
            {
                object error = new { Status = exception.Message };
                return this.Json(error);
            }
        }

        [HttpPost]
        public ActionResult SendTileNotification(MpnsTileViewModel vm)
        {
            if (!this.EndpointExists(vm.ApplicationId, vm.TileId, vm.ClientId, vm.ChannelUrl))
            {
                object error = new { Status = "Error sending notification: Endpoint does not exist." };
                return this.Json(error);
            }

            var backgroundImageUri = string.IsNullOrEmpty(vm.BackgroundImageUri) ? null : new Uri(vm.BackgroundImageUri);
            var backBackgroundImageUri = string.IsNullOrEmpty(vm.BackBackgroundImageUri) ? null : new Uri(vm.BackBackgroundImageUri);

            try
            {
                var notification = new TilePushNotificationMessage()
                {
                    ClearBackBackgroundImageUri = vm.ClearBackBackgroundImageUri,
                    BackBackgroundImageUri = vm.ClearBackBackgroundImageUri ? null : backBackgroundImageUri,
                    ClearBackContent = vm.ClearBackContent,
                    BackContent = vm.ClearBackContent ? null : this.Escape(vm.BackContent),
                    ClearBackTitle = vm.ClearBackTitle,
                    BackTitle = vm.ClearBackTitle ? null : this.Escape(vm.BackTitle),
                    ClearCount = vm.ClearCount,
                    Count = vm.ClearCount ? 0 : vm.Count,
                    ClearTitle = vm.ClearTitle,
                    Title = vm.ClearTitle ? null : this.Escape(vm.Title),
                    BackgroundImageUri = backgroundImageUri,
                    SecondaryTile = vm.TileId,
                    SendPriority = vm.Priority
                };

                var result = notification.Send(new Uri(vm.ChannelUrl));

                object response =
                    new
                    {
                        SubscriptionStatus = result.SubscriptionStatus.ToString(),
                        DeviceConnectionStatus = result.DeviceConnectionStatus.ToString(),
                        NotificationStatus = result.NotificationStatus.ToString(),
                        Status = result.LookupDeliveryStatus()
                    };

                return this.Json(response);
            }
            catch (ArgumentOutOfRangeException exception)
            {
                object error = new { Status = exception.Message };
                return this.Json(error);
            }
            catch (InvalidOperationException exception)
            {
                object error = new { Status = exception.Message };
                return this.Json(error);
            }
        }

        [HttpPost]
        public ActionResult GetSendTemplate(MpnsTemplateSelection templateOptions)
        {
            PartialViewResult result = null;
            switch (templateOptions.NotificationType)
            {
                case "Raw":
                    result = PartialView(
                        "_Raw",
                        new MpnsRawViewModel
                            {
                                ChannelUrl = templateOptions.Url,
                                ApplicationId = templateOptions.ApplicationId,
                                ClientId = templateOptions.ClientId,
                                TileId = templateOptions.TileId,
                                Priority = MessageSendPriority.High
                            });
                    break;
                case "Toast":
                    result = PartialView(
                        "_Toast",
                        new MpnsToastViewModel
                            {
                                Priority = MessageSendPriority.High,
                                ChannelUrl = templateOptions.Url,
                                ApplicationId = templateOptions.ApplicationId,
                                TileId = templateOptions.TileId,
                                ClientId = templateOptions.ClientId
                            });
                    break;
                case "Tile":
                    var images = this.cloudBlobClient.GetAllBlobsInContainer(this.tileImagesContainerName).OrderBy(i => i.FileName).ToList();
                    images.Insert(0, new BlobFileInfo { FileName = "Choose a tile background", FileUri = string.Empty });
                    ViewBag.TileImages = images;
                    result = PartialView(
                        "_Tile",
                        new MpnsTileViewModel
                            {
                                Priority = MessageSendPriority.High,
                                ChannelUrl = templateOptions.Url,
                                ApplicationId = templateOptions.ApplicationId,
                                TileId = templateOptions.TileId,
                                ClientId = templateOptions.ClientId
                            });
                    break;
            }

            return result;
        }

        private string Escape(string text)
        {
            return System.Security.SecurityElement.Escape(text);
        }

        private bool EndpointExists(string applicationId, string tileId, string clientId, string channelUri)
        {
            var endpoint = this.endpointRepository.Find(applicationId, tileId, clientId);
            return endpoint != null && endpoint.ChannelUri.Equals(channelUri);
        }
    }
}