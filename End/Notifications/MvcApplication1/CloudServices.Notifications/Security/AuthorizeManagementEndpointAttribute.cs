namespace MvcApplication1.CloudServices.Notifications
{
    using System;
    using System.Web.Http.Controllers;

    internal sealed class AuthorizeManagementEndpointAttribute : FuncBasedAuthorizationFilterAttribute
    {
        public override Func<HttpActionContext, bool> Filter
        {
            get { return NotificationServiceContext.Current.Configuration.AuthorizeManagementRequest; }
        }
    }
}
