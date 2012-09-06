namespace $rootnamespace$.ViewModels
{
    using System;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Globalization;
    using System.IO;
	using $rootnamespace$.Phone.Notifications;
    using Microsoft.Phone.Notification;

    public class NotificationsPageViewModel : INotifyPropertyChanged
    {
        private readonly IPushClient pushUserRegistrationClient;

        private string message;
        private bool canEnableOrDisablePush = true;

        public NotificationsPageViewModel()
            : this(PushContext.Current.ResolvePushClient())
        {
        }

        public NotificationsPageViewModel(IPushClient pushUserRegistrationClient)
        {
            this.pushUserRegistrationClient = pushUserRegistrationClient;
            this.Notifications = new ObservableCollection<string>();

            PushContext.Current.RawNotification += this.OnRawNotification;
            PushContext.Current.PropertyChanged +=
                (s, e) =>
                {
                    if (e.PropertyName.Equals("IsConnected", StringComparison.OrdinalIgnoreCase))
                    {
                        this.NotifyPropertyChanged("ConnectionStatus");
                    }
                };
        }

        public event PropertyChangedEventHandler PropertyChanged;

        public bool IsPushEnabled
        {
            get
            {
                return PushContext.Current.IsPushEnabled;
            }

            set
            {
                if (PushContext.Current.IsPushEnabled != value)
                {
                    PushContext.Current.IsPushEnabled = value;
                    if (PushContext.Current.IsPushEnabled)
                    {
                        this.Connect();
                    }
                    else
                    {
                        this.Disconnect();
                    }

                    this.NotifyPropertyChanged("IsPushEnabled");
                }
            }
        }

        public bool CanEnableOrDisablePush
        {
            get
            {
                return this.canEnableOrDisablePush;
            }

            set
            {
                if (this.canEnableOrDisablePush != value)
                {
                    this.canEnableOrDisablePush = value;
                    this.NotifyPropertyChanged("CanEnableOrDisablePush");
                }
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic", Justification = "This property is binded in the UI.")]
        public string ConnectionStatus
        {
            get
            {
                return PushContext.Current.IsConnected ? "Connected" : "Disconnected";
            }
        }

        public string Message
        {
            get
            {
                return this.message;
            }

            set
            {
                if (this.message != value)
                {
                    this.message = value;
                    this.NotifyPropertyChanged("Message");
                }
            }
        }

        public ObservableCollection<string> Notifications { get; private set; }

        public void Connect()
        {
            this.Message = "Registering with Push Notification Service...";
            this.CanEnableOrDisablePush = false;

            this.pushUserRegistrationClient.Register(
                r =>
                {
                    if (!r.Success)
                    {
                        this.Message = string.Format(CultureInfo.InvariantCulture, "An error occurred while connecting with Push Notification Service: {0}", r.ErrorMessage);
                    }
                    else
                    {
                        this.Message = "Successfully registered with Push Notification Service.";
                    }

                    this.CanEnableOrDisablePush = true;
                });
        }

        public void Disconnect()
        {
            this.Message = "Unregistering from Push Notification Service...";
            this.CanEnableOrDisablePush = false;

            this.pushUserRegistrationClient.Unregister(
                r =>
                {
                    if (!r.Success)
                    {
                        this.Message = string.Format(CultureInfo.InvariantCulture, "An error occurred while disconnecting from Push Notification Service: {0}", r.ErrorMessage);
                    }
                    else
                    {
                        this.Message = "Successfully disconnected from Push Notification Service.";
                    }

                    this.CanEnableOrDisablePush = true;
                });
        }

        public void ClearMessages()
        {
            this.Notifications.Clear();
        }

        protected virtual void NotifyPropertyChanged(string propertyName)
        {
            var propertyChanged = this.PropertyChanged;
            if (propertyChanged != null)
            {
                propertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        private void OnRawNotification(object sender, HttpNotificationEventArgs e)
        {
            try
            {
                e.Notification.Body.Position = 0;

                var stream = new StreamReader(e.Notification.Body);
                var rawMessage = stream.ReadToEnd();
                this.Notifications.Insert(0, rawMessage);

                this.Message = string.Format(CultureInfo.InvariantCulture, "Push notification received at {0}.", DateTime.Now.ToLongTimeString());
            }
            catch (Exception exception)
            {
                this.Message = string.Format(CultureInfo.InvariantCulture, "There was an error receiving last push notification: {0}", exception.Message);
            }
        }
    }
}
