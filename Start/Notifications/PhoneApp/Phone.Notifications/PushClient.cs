namespace PhoneApp.Phone.Notifications
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Net;
    using System.Net.Browser;
    using System.Runtime.Serialization.Json;
    using System.ServiceModel.Security;
    using System.Windows.Threading;

    public class PushClient : IPushClient
    {
        private readonly Uri endpointsServiceUri;
        private readonly Action<WebRequest> signRequestDelegate;
        private readonly Dispatcher dispatcher;
        private readonly string applicationId;
        private readonly string clientId;
        private readonly string deviceType;
        private readonly IList<Uri> notificationEndpoints = new List<Uri>();
        private static Uri primaryTileEnpointIdentifier = new Uri("/", UriKind.Relative);
        private string channelUri;

        public PushClient(Uri endpointsServiceUri, Action<WebRequest> signRequestDelegate, string applicationId, string clientId, string deviceType, Dispatcher dispatcher = null)
        {
            if (endpointsServiceUri == null)
                throw new ArgumentNullException("endpointsServiceUri");

            if (signRequestDelegate == null)
                throw new ArgumentNullException("signRequestDelegate");

            if (string.IsNullOrWhiteSpace(applicationId))
                throw new ArgumentNullException("applicationId");

            if (string.IsNullOrWhiteSpace(clientId))
                throw new ArgumentNullException("clientId");

            if (string.IsNullOrWhiteSpace(deviceType))
                throw new ArgumentNullException("deviceType");

            this.endpointsServiceUri = endpointsServiceUri;
            this.signRequestDelegate = signRequestDelegate;
            this.applicationId = applicationId;
            this.clientId = clientId;
            this.deviceType = deviceType;
            this.dispatcher = dispatcher;
        }

        public void Register(Action<PushRegistrationResponse> callback, Uri tileNavigationUri = null)
        {
            if (string.IsNullOrWhiteSpace(this.channelUri))
            {
                EventHandler<PushContextErrorEventArgs> errorHandler = null;
                errorHandler =
                    (s, e) =>
                    {
                        PushContext.Current.Error -= errorHandler;
                        this.DispatchCallback(callback, new PushRegistrationResponse(false, e.Exception.Message));
                    };

                PushContext.Current.Error += errorHandler;
                PushContext.Current.Connect(
                    c =>
                    {
                        PushContext.Current.Error -= errorHandler;

                        this.channelUri = c.ChannelUri.AbsoluteUri;
                        this.PutEndpoint(tileNavigationUri, callback);
                    });
            }
            else
            {
                this.PutEndpoint(tileNavigationUri, callback);
            }
        }

        public void Unregister(Action<PushRegistrationResponse> callback, Uri tileNavigationUri = null)
        {
            this.DeleteEndpoint(callback, tileNavigationUri);

            if (this.notificationEndpoints.Count == 0)
            {
                PushContext.Current.Disconnect();
            }
        }

        protected virtual void DispatchCallback(Action<PushRegistrationResponse> callback, PushRegistrationResponse response)
        {
            if (callback != null)
            {
                if (this.dispatcher != null)
                    this.dispatcher.BeginInvoke(() => callback(response));
                else
                    callback(response);
            }
        }

        protected virtual HttpWebRequest ResolveRequest(Uri requestUri)
        {
            return (HttpWebRequest)WebRequestCreator.ClientHttp.Create(requestUri);
        }

        private void PutEndpoint(Uri tileNavigationUri, Action<PushRegistrationResponse> callback)
        {
            var endpointIdentifier = tileNavigationUri ?? primaryTileEnpointIdentifier;

            if (this.notificationEndpoints.Contains(endpointIdentifier)) throw new InvalidOperationException("Navigation Uri already registered.");

            var endpoint = new Endpoint
            {
                ApplicationId = this.applicationId,
                ClientId = this.clientId,
                DeviceType = this.deviceType,
                ChannelUri = this.channelUri,
                TileId = tileNavigationUri != null ?
                    tileNavigationUri.ToString() :
                    string.Empty
            };

            var request = this.ResolveRequest(this.endpointsServiceUri);
            request.Method = "PUT";
            request.ContentType = "application/json";
            request.Accept = "application/json";

            byte[] body;
            using (var stream = new MemoryStream())
            {
                var serializer = new DataContractJsonSerializer(typeof(Endpoint));
                serializer.WriteObject(stream, endpoint);

                body = stream.ToArray();
            }

            try
            {
                this.signRequestDelegate(request);
                request.BeginGetRequestStream(
                    ar =>
                    {
                        var postStream = request.EndGetRequestStream(ar);

                        postStream.Write(body, 0, body.Length);
                        postStream.Close();

                        request.BeginGetResponse(
                            asyncResult =>
                            {
                                try
                                {
                                    var response = request.EndGetResponse(asyncResult) as HttpWebResponse;
                                    if ((response != null) && (response.StatusCode == HttpStatusCode.Accepted))
                                    {
                                        this.DispatchCallback(callback, new PushRegistrationResponse(true, string.Empty));
                                        this.notificationEndpoints.Add(endpointIdentifier);
                                    }
                                    else
                                    {
                                        this.DispatchCallback(callback, new PushRegistrationResponse(false, "The specified endpoint could not be registered in the Endpoints service."));
                                    }
                                }
                                catch (WebException webException)
                                {
                                    this.DispatchCallback(callback, new PushRegistrationResponse(false, Helpers.ParseWebException(webException)));
                                }
                            },
                        null);
                    },
                request);
            }
            catch (ArgumentNullException exception)
            {
                this.DispatchCallback(callback, new PushRegistrationResponse(false, exception.Message));
            }
            catch (MessageSecurityException exception)
            {
                this.DispatchCallback(callback, new PushRegistrationResponse(false, exception.Message));
            }
        }

        private void DeleteEndpoint(Action<PushRegistrationResponse> callback, Uri tileNavigationUri)
        {
            var endpointIdentifier = tileNavigationUri ?? primaryTileEnpointIdentifier;

            if (!this.notificationEndpoints.Contains(endpointIdentifier)) throw new InvalidOperationException("Navigation Uri is not registered. Call register method first.");

            var builder = new UriBuilder(this.endpointsServiceUri);
            builder.Path += string.Format(
                CultureInfo.InvariantCulture,
                "/{0}/{1}",
                this.applicationId,
                this.clientId);

            if (tileNavigationUri != null)
            {
                builder.Query = string.Format(
                        CultureInfo.InvariantCulture,
                        "tileId={0}",
                        tileNavigationUri.ToString());
            }

            var request = this.ResolveRequest(builder.Uri);
            request.Method = "DELETE";

            try
            {
                this.signRequestDelegate(request);
                request.BeginGetResponse(
                    asyncResult =>
                    {
                        try
                        {
                            var response = request.EndGetResponse(asyncResult) as HttpWebResponse;
                            if ((response != null) && (response.StatusCode == HttpStatusCode.Accepted))
                            {
                                this.DispatchCallback(callback, new PushRegistrationResponse(true, string.Empty));
                                this.notificationEndpoints.Remove(endpointIdentifier);
                            }
                            else
                            {
                                this.DispatchCallback(callback, new PushRegistrationResponse(false, "The specified endpoint could not be unregistered in the Endpoints service."));
                            }
                        }
                        catch (WebException webException)
                        {
                            this.DispatchCallback(callback, new PushRegistrationResponse(false, Helpers.ParseWebException(webException)));
                        }
                    },
                null);
            }
            catch (InvalidOperationException exception)
            {
                this.DispatchCallback(callback, new PushRegistrationResponse(false, exception.Message));
            }
            catch (ArgumentNullException exception)
            {
                this.DispatchCallback(callback, new PushRegistrationResponse(false, exception.Message));
            }
            catch (MessageSecurityException exception)
            {
                this.DispatchCallback(callback, new PushRegistrationResponse(false, exception.Message));
            }
        }
    }
}
