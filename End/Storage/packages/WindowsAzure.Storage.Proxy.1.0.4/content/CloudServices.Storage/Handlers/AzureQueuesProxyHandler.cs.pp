namespace $rootnamespace$.CloudServices.Storage.Handlers
{
    using System;
    using System.Net.Http;
    using $rootnamespace$.CloudServices.Storage.Helpers;

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
