using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using Microsoft.WindowsAzure.Samples.Data.Services.Client;
using Microsoft.WindowsAzure.Samples.Phone.Storage;
using System.Globalization;

namespace UploadPicToWAStorage
{
    public partial class ListItems : PhoneApplicationPage
    {
        public ListItems()
        {
            InitializeComponent();
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            DataServiceCollection<SampleData> sampleDataCollection;
            var context = CloudStorageContext.Current.Resolver.CreateTableServiceContext();

            sampleDataCollection = new DataServiceCollection<SampleData>(context);
            sampleDataCollection.LoadCompleted += (s2, e2) =>
            {
                List<SampleData> cloudNotes = sampleDataCollection.ToList();
                ListPics.ItemsSource = cloudNotes;
            };

            var tableUri = new Uri(
                string.Format(
                    CultureInfo.InvariantCulture,
                    "{0}/{1}()",
                        context.BaseUri,
                        "pics"),
                UriKind.Absolute);

            sampleDataCollection.Clear();
            sampleDataCollection.LoadAsync(tableUri);
        }


    }
}