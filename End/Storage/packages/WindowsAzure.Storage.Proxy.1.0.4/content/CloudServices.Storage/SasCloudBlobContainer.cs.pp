namespace $rootnamespace$.CloudServices.Storage
{
    using System.Runtime.Serialization;
    
    [DataContract(Name = "Container", Namespace = "")]
    public class SasCloudBlobContainer
    {
        [DataMember]
        public string Name { get; set; }

        [DataMember]        
        public string Url { get; set; }

        [DataMember]
        public SasCloudBlobContainerProperties Properties { get; set; }
    }
}
