namespace MvcApplication1.CloudServices.Storage.Handlers
{
    using System;
    using System.Net.Http;
    using MvcApplication1.CloudServices.Storage.Helpers;

    public class AzureQueuesProxyHandler : StorageProxyHandler
    {
        protected override string AzureStorageEndpoint
        {
            get { return CloudStorageAccount.QueueEndpoint.ToString().TrimEnd('/'); }
        }

        [CLSCompliant(false)]
        protected override void SignRequest(HttpRequestMessage request)
        {
            request.Sign(CloudStorageAccount);
        }
    }
}
