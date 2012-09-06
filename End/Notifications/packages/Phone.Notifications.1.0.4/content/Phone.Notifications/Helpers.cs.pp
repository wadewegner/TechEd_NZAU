namespace $rootnamespace$.Phone.Notifications
{
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.IO.IsolatedStorage;
    using System.Net;

    internal static class Helpers
    {
        internal static T GetIsolatedStorageSetting<T>(string key)
        {
            IDictionary<string, object> isolatedStorage = IsolatedStorageSettings.ApplicationSettings;
            if (!isolatedStorage.ContainsKey(key))
                return default(T);

            return (T)isolatedStorage[key];
        }

        internal static void SetIsolatedStorageSetting(string key, object value)
        {
            IDictionary<string, object> isolatedStorage = IsolatedStorageSettings.ApplicationSettings;
            if (isolatedStorage.ContainsKey(key))
                isolatedStorage.Remove(key);

            isolatedStorage.Add(key, value);
        }

        internal static string GetResponseString(this WebResponse response)
        {
            try
            {
                var stream = response.GetResponseStream();
                var reader = new StreamReader(stream);

                return reader.ReadToEnd();
            }
            catch
            {
                return string.Empty;
            }
        }

        internal static string ParseWebException(WebException webException)
        {
            if (webException == null)
                return string.Empty;

            var responseContent = webException.Response.GetResponseString();
            var response = webException.Response as HttpWebResponse;

            if (response != null)
                return string.Format(CultureInfo.InvariantCulture, "{0} {1}", response.StatusCode, responseContent).Trim();

            if (string.IsNullOrWhiteSpace(responseContent))
                return responseContent;

            return webException.GetBaseException().Message;
        }
    }
}
