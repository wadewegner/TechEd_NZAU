namespace $rootnamespace$.CloudServices.Storage
{
    using System;
    using System.Runtime.Serialization;

    [DataContract(Namespace = "")]
    public class SasCloudBlobContainerProperties
    {
        [DataMember(Name = "Etag")]
        public string ETag { get; set; }

        [DataMember(Name = "Last-Modified")]
        public DateTime LastModifiedUtc { get; set; }
    }
}
