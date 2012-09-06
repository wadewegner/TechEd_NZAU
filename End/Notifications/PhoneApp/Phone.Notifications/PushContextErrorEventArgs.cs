namespace PhoneApp.Phone.Notifications
{
    using System;

    public class PushContextErrorEventArgs : EventArgs
    {
        public PushContextErrorEventArgs(Exception exception)
        {
            Exception = exception;
        }

        public Exception Exception { get; private set; }
    }
}
