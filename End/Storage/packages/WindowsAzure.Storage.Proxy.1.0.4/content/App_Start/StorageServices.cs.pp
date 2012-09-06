[assembly: WebActivator.PreApplicationStartMethod(typeof($rootnamespace$.App_Start.StorageServices), "PreStart")]

namespace $rootnamespace$.App_Start
{
    using System.Web.Routing;
    using Microsoft.WindowsAzure;
    using $rootnamespace$.CloudServices.Storage;

    public class StorageServices
    {
        public static void PreStart()
        {
            // Configure the default values for the Storage Proxy and SAS Services:
            // - Anonymous access
            // - Windows Azure Storage Emulator
            StorageServicesContext.Current.Configure(
                c =>
                    {
                        // TODO: Specify additional authentication rules
                        c.AuthenticateRequest = currentRequest => true;

                        // TODO: Specify a rule for whether users can access the Blob SAS Service
                        c.AuthorizeBlobsAccess = currentRequest => true;

                        // TODO: Specify a rule for whether users can access the Queues Proxy Service
                        c.AuthorizeQueuesAccess = currentRequest => true;

                        // TODO: Specify a rule for whether users can access the Tables Proxy Service
                        c.AuthorizeTablesAccess = currentRequest => true;

                        // TODO: Specify in minutes for how long the generated Blob's SAS are valid
                        c.BlobsSasExpirationTime = 15;

                        // TODO: Specify in minutes for how long the generated Blob Container's SAS are valid
                        c.ContainerSasExpirationTime = 15;

                        // TODO: Specify in bytes the maximum size of Windows Azure Storage responses
                        // which the Proxy servers are allowed to read
                        c.WindowsAzureStorageMaximumResponseSize = 1024 * 1024;

                        // TODO: Replace with your own Windows Azure Storage account name and key, or read it
                        // from a configuration file
                        c.CloudStorageAccount = CloudStorageAccount.DevelopmentStorageAccount;

						// TODO: Specify the handlers you want for ASP.NET Web API Registration Service (authentication, logging, etc)
                    	// c.DelegatingHandlers = new[] { // Your DelegatingHandler instances };
                    });

            // Add the route to the Tables Proxy service "/tables"
            RouteTable.Routes.MapTablesProxyServiceRoute("tables");

            // Add the route to the Queues Proxy service "/queues"
            RouteTable.Routes.MapQueuesProxyServiceRoute("queues");

            // Add the route to the Shared Access Signature service "/sas"
            RouteTable.Routes.MapSasServiceRoute("sas");
        }
    }
}