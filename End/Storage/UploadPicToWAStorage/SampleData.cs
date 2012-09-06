using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.WindowsAzure.Samples.Data.Services.Client;
using Microsoft.WindowsAzure.Samples.Phone.Storage;
using System.Globalization;

namespace UploadPicToWAStorage
{
    [DataServiceEntity]
    [EntitySet("pics")]
    public class SampleData : TableServiceEntity
    {
        private string name;
        private string url;

        public SampleData()
            : base(
                  "PartitionKey",
                  string.Format(
                      CultureInfo.InvariantCulture,
                      "{0:10}_{1}",
                      DateTime.MaxValue.Ticks - DateTime.Now.Ticks,
                      Guid.NewGuid()))
        {
        }

        public SampleData(string partitionKey, string rowKey)
            : base(partitionKey, rowKey)
        {
        }

        public string Name
        {
            get
            {
                return this.name;
            }

            set
            {
                this.name = value;
                this.OnPropertyChanged("Name");
            }
        }

        public string Url
        {
            get
            {
                return this.url;
            }

            set
            {
                this.url = value;
                this.OnPropertyChanged("Url");
            }
        }
    }
}
