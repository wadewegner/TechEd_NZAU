namespace MvcApplication1.CloudServices.Storage.Helpers
{
    using System;
    using System.Globalization;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Web.Http;

    public static class Extensions
    {
        private const string ErrorResponse = "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\" ?><error {0}><code>{1}</code><message xml:lang=\"en-US\">{2}</message></error>";
        private const string DataServiceNamespace = "xmlns=\"http://schemas.microsoft.com/ado/2007/08/dataservices/metadata\"";

        [CLSCompliant(false)]
        public static HttpContent CloneContent(this HttpContent requestContent, string content)
        {
            if (requestContent == null)
            {
                throw new ArgumentNullException("requestContent");
            }

            var result = new StringContent(content);

            result.Headers.ContentType = new MediaTypeHeaderValue("application/atom+xml");
            result.Headers.Expires = requestContent.Headers.Expires;
            result.Headers.LastModified = requestContent.Headers.LastModified;

            return result;
        }

        [CLSCompliant(false)]
        public static HttpResponseException StorageException(HttpStatusCode code, string error, string detail)
        {
            var response = new HttpResponseMessage(code);

            var errorMessage = string.Format(CultureInfo.InvariantCulture, ErrorResponse, DataServiceNamespace, error, detail);
            response.ReasonPhrase = error;
            response.Content = new StringContent(errorMessage);
            response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/atom+xml");

            return new HttpResponseException(response);
        }
    }
}
