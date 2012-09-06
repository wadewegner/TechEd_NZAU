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