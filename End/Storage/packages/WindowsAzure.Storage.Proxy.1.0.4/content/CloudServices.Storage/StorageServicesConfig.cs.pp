namespace $rootnamespace$.CloudServices.Storage
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Web.Http;
    using System.Web.Http.Controllers;
    using Microsoft.WindowsAzure;

    public class StorageServicesConfig
    {
        private const int DefaultMaximmumResponseSize = 1024 * 1024;
        private const int DefaultSasExpirationSize = 15;

        private Func<HttpActionContext, bool> authorizeQueuesAccess;
        private Func<HttpActionContext, bool> authorizeTablesAccess;
        private Func<HttpActionContext, bool> authorizeBlobsAccess;
        private Func<HttpActionContext, bool> authenticateRequest;
        private Func<HttpRequestMessage, string> mapUserName;
        private IEnumerable<DelegatingHandler> delegatingHandlers;

        private int containerSasExpirationTime;
        private int blobsSasExpirationTime;
        private int windowsAzureStorageMaximmumResponseSize;

        public StorageServicesConfig()
        {
            this.delegatingHandlers = new DelegatingHandler[] { };
        }

        public CloudStorageAccount CloudStorageAccount { get; set; }

        public int WindowsAzureStorageMaximumResponseSize
        {
            get
            {
                if (this.windowsAzureStorageMaximmumResponseSize == 0)
                    this.WindowsAzureStorageMaximumResponseSize = DefaultMaximmumResponseSize;

                return this.windowsAzureStorageMaximmumResponseSize;
            }

            set
            {
                this.windowsAzureStorageMaximmumResponseSize = value;
            }
        }

        public int ContainerSasExpirationTime
        {
            get
            {
                if (this.containerSasExpirationTime == 0)
                    this.ContainerSasExpirationTime = DefaultSasExpirationSize;

                return this.containerSasExpirationTime;
            }

            set
             {
                 this.containerSasExpirationTime = value;
             }
        }

        public int BlobsSasExpirationTime
        {
            get
            {
                if (this.blobsSasExpirationTime == 0)
                    this.BlobsSasExpirationTime = DefaultSasExpirationSize;

                return this.blobsSasExpirationTime;
            }

            set
            {
                this.blobsSasExpirationTime = value;
            }
        }

        public Func<HttpActionContext, bool> AuthorizeTablesAccess
        {
            get
            {
                return this.authorizeTablesAccess ?? (this.AuthorizeTablesAccess = DefaultAnonymousAccess);
            }

            set { this.authorizeTablesAccess = value; }
        }

        public Func<HttpActionContext, bool> AuthorizeQueuesAccess
        {
            get
            {
                return this.authorizeQueuesAccess ?? (this.AuthorizeQueuesAccess = DefaultAnonymousAccess);
            }

            set { this.authorizeQueuesAccess = value; }
        }

        public Func<HttpActionContext, bool> AuthorizeBlobsAccess
        {
            get
            {
                return this.authorizeBlobsAccess ?? (this.AuthorizeBlobsAccess = DefaultAnonymousAccess);
            }

            set { this.authorizeBlobsAccess = value; }
        }

        public Func<HttpActionContext, bool> AuthenticateRequest
        {
            get
            {
                if (this.authenticateRequest == null)
                    this.AuthenticateRequest = DefaultAnonymousAccess;

                return this.authenticateRequest;
            }

            set { this.authenticateRequest = value; }
        }

        public Func<HttpRequestMessage, string> MapUserName
        {
            get
            {
                if (this.mapUserName == null)
                    this.MapUserName = DefaultUsernameMapper;

                return this.mapUserName;
            }

            set { this.mapUserName = value; }
        }

        public IEnumerable<DelegatingHandler> DelegatingHandlers
        {
            get
            {
                return this.delegatingHandlers;
            }

            set
            {
                this.delegatingHandlers = value;
                GlobalConfiguration.Configuration.AddDelegatingHandlers(value.ToArray());
            }
        }

        private static bool DefaultAnonymousAccess(HttpActionContext message)
        {
            // By default, return always true (anonymous user)
            return true;
        }

        private static string DefaultUsernameMapper(HttpRequestMessage message)
        {
            // By default, return an empty username (anonymous user)
            return string.Empty;
        }
    }
}
