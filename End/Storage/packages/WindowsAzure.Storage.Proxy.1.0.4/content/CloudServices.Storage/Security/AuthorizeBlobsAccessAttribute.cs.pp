namespace $rootnamespace$.CloudServices.Storage.Security
{
    using System;
    using System.Net.Http;
    using System.Web.Http.Controllers;

    [AttributeUsage(AttributeTargets.Method, Inherited = false, AllowMultiple = false)]
    internal sealed class AuthorizeBlobsAccessAttribute : FuncBasedAuthorizationFilterAttribute
    {
        public override Func<HttpActionContext, bool> Filter
        {
            get { return StorageServicesContext.Current.Configuration.AuthorizeBlobsAccess; }
        }
    }
}
