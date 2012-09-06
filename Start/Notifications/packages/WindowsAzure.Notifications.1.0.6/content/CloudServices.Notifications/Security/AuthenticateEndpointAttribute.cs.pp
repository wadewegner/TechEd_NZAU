namespace $rootnamespace$.CloudServices.Notifications
{
    using System;
    using System.Web.Http.Controllers;

    internal sealed class AuthenticateEndpointAttribute : FuncBasedAuthorizationFilterAttribute
    {
        public override Func<HttpActionContext, bool> Filter
        {
            get { return NotificationServiceContext.Current.Configuration.AuthenticateRequest; }
        }
    }
}
