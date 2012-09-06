namespace MvcApplication1.Areas.Notifications
{
    using System.Web.Mvc;

    public class NotificationAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Notifications";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Notifications_default",
                "Notifications/{controller}/{action}/{id}",
                new { controller = "PushNotifications", action = "Index", id = (string)null });
        }
    }
}
