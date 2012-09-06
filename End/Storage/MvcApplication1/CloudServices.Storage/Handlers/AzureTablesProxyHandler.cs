namespace MvcApplication1.CloudServices.Storage.Handlers
{
    using System;
    using System.Net.Http;
    using MvcApplication1.CloudServices.Storage.Helpers;

    public class AzureTablesProxyHandler : StorageProxyHandler
    {
        protected override string AzureStorageEndpoint
        {
            get
            {
                return CloudStorageAccount.TableEndpoint.ToString().TrimEnd('/');
            }
        }

        [CLSCompliant(false)]
        protected override void SignRequest(HttpRequestMessage request)
        {
            request.SignLite(CloudStorageAccount);
        }
    }
}
