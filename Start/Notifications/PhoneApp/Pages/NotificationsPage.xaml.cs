namespace PhoneApp.Pages
{
    using System;
    using System.Windows;
    using Microsoft.Phone.Controls;
    using PhoneApp.ViewModels;

    public partial class NotificationsPage : PhoneApplicationPage
    {
        public NotificationsPage()
        {
            this.InitializeComponent();

            this.ViewModel = new NotificationsPageViewModel();
            this.Loaded += this.OnNotificationsPageLoaded;
        }

        public NotificationsPageViewModel ViewModel
        {
            get { return this.DataContext as NotificationsPageViewModel; }
            set { this.DataContext = value; }
        }

        private void OnNotificationsPageLoaded(object sender, RoutedEventArgs args)
        {
            if (this.ViewModel.IsPushEnabled)
            {
                this.ViewModel.Connect();
            }
        }

        private void OnClear(object sender, EventArgs e)
        {
            this.ViewModel.ClearMessages();
        }
    }
}