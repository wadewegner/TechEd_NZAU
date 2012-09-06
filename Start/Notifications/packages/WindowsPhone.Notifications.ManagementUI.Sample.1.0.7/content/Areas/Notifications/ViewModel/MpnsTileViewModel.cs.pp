namespace $rootnamespace$.Areas.Notifications.ViewModel
{
    using Microsoft.WindowsPhone.Samples.Notifications;

    public class MpnsTileViewModel : MpnsBaseViewModel
    {
        public MpnsTileViewModel()
        {
            this.ClearBackBackgroundImageUri = false;
            this.BackBackgroundImageUri = string.Empty;

            this.ClearBackContent = false;
            this.BackContent = string.Empty;

            this.ClearBackTitle = false;
            this.BackTitle = string.Empty;

            this.ClearCount = false;
            this.Count = 1;

            this.ClearTitle = false;
            this.Title = string.Empty;

            this.BackgroundImageUri = string.Empty;

            Priority = MessageSendPriority.Normal;
        }

        public bool ClearBackBackgroundImageUri { get; set; }

        public string BackBackgroundImageUri { get; set; }

        public bool ClearBackContent { get; set; }

        public string BackContent { get; set; }

        public bool ClearBackTitle { get; set; }

        public string BackTitle { get; set; }

        public bool ClearTitle { get; set; }

        public string Title { get; set; }

        public bool ClearCount { get; set; }

        public int Count { get; set; }

        public string BackgroundImageUri { get; set; }
    }
}
