namespace MvcApplication1.Areas.Notifications.ViewModel
{
    using Microsoft.WindowsPhone.Samples.Notifications;

    public class MpnsRawViewModel : MpnsBaseViewModel
    {
        public MpnsRawViewModel()
        {
            this.Text = string.Empty;
            Priority = MessageSendPriority.Normal;
        }

        public string Text { get; set; }
    }
}