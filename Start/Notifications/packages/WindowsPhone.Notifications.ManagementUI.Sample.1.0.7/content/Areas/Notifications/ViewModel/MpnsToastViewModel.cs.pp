namespace $rootnamespace$.Areas.Notifications.ViewModel
{
    using Microsoft.WindowsPhone.Samples.Notifications;

    public class MpnsToastViewModel : MpnsBaseViewModel
    {
        public MpnsToastViewModel()
        {
            this.Title = string.Empty;
            this.SubTitle = string.Empty;
            Priority = MessageSendPriority.Normal;
        }

        public string Title { get; set; }

        public string SubTitle { get; set; }

        public string TargetPage { get; set; }
    }
}