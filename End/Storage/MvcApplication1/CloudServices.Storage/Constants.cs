namespace MvcApplication1.CloudServices.Storage
{
    public class Constants
    {
        public const string CloudStorageAccountNullArgumentErrorMessage = "The Storage Account setting cannot be null.";

        public const string CompMustBeSasArgumentErrorMessage = "Argument comp must be sas for this operation.";

        public const string ConfigureActionArgumentNullErrorMessage = "Parameter configureAction cannot be null.";

        public const string ContainerCannotBeNullErrorMessage = "Container can not be null.";

        public const string ContainerNameNullArgumentErrorMessage = "The containerName cannot be null.";

        public const string HttpClientDisposedErrorString = "The connection with Windows Azure has been closed before the result could be read.";

        public const string InvalidPublicAccessModeArgumentErrorMessage = "Container Access Mode is invalid.";

        public const string PublicAccessNotSpecifiedErrorMessage = "You have specified an ACL operation but not sent the required HTTP header.";

        public const string RequestCannotBeNullErrorMessage = "Request can not be null.";

        public const string RequestNullErrorMessage = "Called service with null HttpRequestMessage.";

        public const string ResponseNullArgumentErrorString = "Response can not be null.";

        public const string WindowsAzureStorageExceptionStringMessage = "There was an error when sending data to Windows Azure Storage.";
    }
}
