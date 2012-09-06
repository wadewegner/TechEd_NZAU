namespace PhoneApp.Phone.Notifications
{
    using System;

    public interface IPushClient
    {
        void Register(Action<PushRegistrationResponse> callback, Uri tileNavigationUri = null);

        void Unregister(Action<PushRegistrationResponse> callback, Uri tileNavigationUri = null);
    }
}
