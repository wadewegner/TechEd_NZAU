namespace MvcApplication1.Areas.Notifications.ViewModel
{
    using System.ComponentModel;

    public class BlobFileInfo
    {
        [DisplayName("Name")]
        public string FileName { get; set; }

        [DisplayName("Uri")]
        public string FileUri { get; set; }
    }
}
