namespace $rootnamespace$.CloudServices.Storage
{
    using System;
    using System.Net;
    using System.Net.Http;
    using System.Web.Http;
    using $rootnamespace$.CloudServices.Storage.Handlers;
    using $rootnamespace$.CloudServices.Storage.Helpers;
    using $rootnamespace$.CloudServices.Storage.Security;

    public class QueuesProxyController : ApiController
    {
        private static readonly AzureQueuesProxyHandler Proxy = new AzureQueuesProxyHandler();

        [AuthorizeQueuesAccess, CLSCompliant(false)]
        public HttpResponseMessage Post([FromUri]string path)
        {
            if (this.Request == null)
                throw Extensions.StorageException(HttpStatusCode.BadRequest, Constants.RequestCannotBeNullErrorMessage, Constants.RequestCannotBeNullErrorMessage);

            this.Request.Properties[StorageProxyHandler.RequestedPathPropertyName] = path ?? string.Empty;
            return Proxy.ProcessRequest(this.Request);
        }

        [AuthorizeQueuesAccess, CLSCompliant(false)]
        public HttpResponseMessage Put([FromUri]string path)
        {
            if (this.Request == null)
                throw Extensions.StorageException(HttpStatusCode.BadRequest, Constants.RequestCannotBeNullErrorMessage, Constants.RequestCannotBeNullErrorMessage);

            this.Request.Properties[StorageProxyHandler.RequestedPathPropertyName] = path ?? string.Empty;
            return Proxy.ProcessRequest(this.Request);
        }

        [AuthorizeQueuesAccess, CLSCompliant(false)]
        public HttpResponseMessage Get(string path)
        {
            if (this.Request == null)
                throw Extensions.StorageException(HttpStatusCode.BadRequest, Constants.RequestCannotBeNullErrorMessage, Constants.RequestCannotBeNullErrorMessage);

            this.Request.Properties[StorageProxyHandler.RequestedPathPropertyName] = path ?? string.Empty;
            return Proxy.ProcessRequest(this.Request);
        }

        [AuthorizeQueuesAccess, CLSCompliant(false)]
        public HttpResponseMessage Delete(string path)
        {
            if (this.Request == null)
                throw Extensions.StorageException(HttpStatusCode.BadRequest, Constants.RequestCannotBeNullErrorMessage, Constants.RequestCannotBeNullErrorMessage);

            this.Request.Properties[StorageProxyHandler.RequestedPathPropertyName] = path ?? string.Empty;
            return Proxy.ProcessRequest(this.Request);
        }

        [AuthorizeQueuesAccess, CLSCompliant(false)]
        [AcceptVerbs("HEAD")]
        public HttpResponseMessage Head(string path)
        {
            if (this.Request == null)
                throw Extensions.StorageException(HttpStatusCode.BadRequest, Constants.RequestCannotBeNullErrorMessage, Constants.RequestCannotBeNullErrorMessage);

            this.Request.Properties[StorageProxyHandler.RequestedPathPropertyName] = path ?? string.Empty;
            return Proxy.ProcessRequest(this.Request);
        }
    }
}
