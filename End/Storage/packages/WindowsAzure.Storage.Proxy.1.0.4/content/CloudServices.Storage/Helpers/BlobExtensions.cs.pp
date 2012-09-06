namespace $rootnamespace$.CloudServices.Storage.Helpers
{
    using System;

    public static class BlobExtensions
    {
        public static SasCloudBlobContainer ToModel(this Microsoft.WindowsAzure.StorageClient.CloudBlobContainer container)
        {
            if (container == null)
            {
                throw new ArgumentNullException("container", Constants.ContainerCannotBeNullErrorMessage);
            }

            return new SasCloudBlobContainer
            {
                Name = container.Name,
                Url = container.Uri.AbsoluteUri,
                Properties = new SasCloudBlobContainerProperties
                {
                    ETag = container.Properties.ETag,
                    LastModifiedUtc = container.Properties.LastModifiedUtc
                }
            };
        }
    }
}
