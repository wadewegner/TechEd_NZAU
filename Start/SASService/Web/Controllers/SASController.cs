using Microsoft.WindowsAzure;
using Microsoft.WindowsAzure.StorageClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Web.Controllers
{
    public class SASController : ApiController
    {
        string containerName = @"containername";
        string storageAccountName = @"YOURACCOUNTNAME";
        string storageAccountKey = @"YOURACCOUNTKEY";

        // GET api/sas
        public string Get()
        {
            string blobName = @"image.jpg";
            string contentType = "image/jpeg";

            return Get(blobName, contentType);
        }


        public string Get(string blobName, string contentType)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(
                string.Format("DefaultEndpointsProtocol=http;AccountName={0};AccountKey={1}", 
                storageAccountName, storageAccountKey));

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            CloudBlobContainer blobContainer = blobClient.GetContainerReference(containerName);
            blobContainer.CreateIfNotExist();

            BlobContainerPermissions containerPermissions = new BlobContainerPermissions();
            containerPermissions.PublicAccess = BlobContainerPublicAccessType.Blob;

            containerPermissions.SharedAccessPolicies.Add("mypolicy", new SharedAccessPolicy()
            {
                Permissions = SharedAccessPermissions.Write | SharedAccessPermissions.Read ,
                SharedAccessExpiryTime = DateTime.Now.Add(TimeSpan.FromHours(4))
            });

            blobContainer.SetPermissions(containerPermissions);

            string sas = blobContainer.GetSharedAccessSignature(new SharedAccessPolicy(), "mypolicy");

            return string.Format("{0}/{1}{2}", blobContainer.Uri, blobName, sas);
        }
    }
}
