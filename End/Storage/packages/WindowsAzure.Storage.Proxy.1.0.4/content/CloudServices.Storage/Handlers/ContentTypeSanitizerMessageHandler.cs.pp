namespace $rootnamespace$.CloudServices.Storage.Handlers
{
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading;

    public class ContentTypeSanitizerMessageHandler : ControllerFilteredMessageProcessingHandler
    {
        protected override HttpRequestMessage ProcessRequestHandler(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            if (request.Content.Headers.ContentType == null)
            {
                // Set the default Content-Type when it is not specified
                request.Content.Headers.ContentType = new MediaTypeHeaderValue("application/xml");
            }

            return request;
        }
    }
}
