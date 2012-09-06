namespace $rootnamespace$.CloudServices.Storage
{
    using System;

    public class StorageServicesContext
    {
        private static readonly StorageServicesContext Instance = new StorageServicesContext();

        private readonly StorageServicesConfig config = new StorageServicesConfig();

        public static StorageServicesContext Current
        {
            get { return Instance; }
        }

        public StorageServicesConfig Configuration
        {
            get { return this.config; }
        }

        public void Configure(Action<StorageServicesConfig> configureAction)
        {
            if (configureAction == null)
                throw new ArgumentException(Constants.ConfigureActionArgumentNullErrorMessage, "configureAction");
            
            configureAction(this.config);
        }
    }
}
