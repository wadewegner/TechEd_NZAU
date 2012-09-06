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
using Microsoft.Phone.Tasks;
using Microsoft.WindowsAzure.Samples.Phone.Storage;

namespace UploadPicToWAStorage
{
    public partial class MainPage : PhoneApplicationPage
    {
        CameraCaptureTask cameraCaptureTask;

        // Constructor
        public MainPage()
        {
            InitializeComponent();

            cameraCaptureTask = new CameraCaptureTask();
            cameraCaptureTask.Completed += new EventHandler<PhotoResult>(cameraCaptureTask_Completed);
        }

        void cameraCaptureTask_Completed(object sender, PhotoResult e)
        {
            if (e.TaskResult == TaskResult.OK && e.ChosenPhoto != null)
            {
                var blobClient = CloudStorageContext.Current.Resolver.CreateCloudBlobClient();
                var container = blobClient.GetContainerReference("pics");
                var imageName = this.ImageName.Text;

                container.CreateIfNotExist(
                    BlobContainerPublicAccessType.Container,
                    response =>
                    {
                        var blob = container.GetBlobReference(imageName);
                        blob.UploadFromStream(
                            e.ChosenPhoto,
                            repsonse2 =>
                            {
                                var tableClient = CloudStorageContext.Current.Resolver.CreateCloudTableClient();
                                var tableName = "pics";

                                tableClient.CreateTableIfNotExist(
                                    tableName,
                                    p =>
                                    {
                                        var context = CloudStorageContext.Current.Resolver.CreateTableServiceContext();
                                        var sampleData = new SampleData { Name = imageName, Url = blob.Uri.ToString() };

                                        context.AddObject(tableName, sampleData);
                                        context.BeginSaveChanges(
                                            asyncResult =>
                                            {
                                                context.EndSaveChanges(asyncResult);
                                            },
                                            null);
                                    });
                            });
                    });
            }
        }


        private void UploadButton_Click(object sender, RoutedEventArgs e)
        {
            cameraCaptureTask.Show();
        }

        private void ViewAllLink_Click(object sender, RoutedEventArgs e)
        {
            NavigationService.Navigate(new Uri("/ListItems.xaml", UriKind.Relative));
        }
    }
}