namespace $rootnamespace$.CloudServices.Storage
{
    using System.Runtime.Serialization;
    
    [DataContract(Name = "EnumerationResults", Namespace = "")]
    public class SasCloudBlobContainerListResponse
    {
        [DataMember]
        public SasCloudBlobContainer[] Containers { get; set; }
    }
}
