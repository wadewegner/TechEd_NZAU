namespace PhoneApp.Phone.Notifications
{
    public class PushRegistrationResponse
    {
        public PushRegistrationResponse(bool success, string errorMessage)
        {
            this.Success = success;
            this.ErrorMessage = errorMessage;
        }

        public bool Success { get; private set; }

        public string ErrorMessage { get; private set; }
    }
}
