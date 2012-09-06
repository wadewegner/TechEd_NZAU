namespace MvcApplication1.CloudServices.Storage
{
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Web.Http;
    using System.Web.Routing;

    public static class RouteExtensions
    {
        public static void MapQueuesProxyServiceRoute(this RouteCollection routes, string prefix)
        {
            routes.MapQueuesProxyServiceRoute(prefix, new DelegatingHandler[] { });
        }

        public static void MapQueuesProxyServiceRoute(this RouteCollection routes, string prefix, params DelegatingHandler[] handlers)
        {
            var currentConfiguration = GlobalConfiguration.Configuration;

            // Handlers
            currentConfiguration.AddDelegatingHandlers(handlers)
                                .AddDelegatingHandlers(
                                    new[] 
                                    { 
                                        new Handlers.ContentTypeSanitizerMessageHandler { ConfiguredControllers = new[] { "QueuesProxy" } } 
                                    });

            // Routes
            routes.MapHttpRoute(
                name: prefix,
                routeTemplate: prefix + "/{*path}",
                defaults: new { Controller = "QueuesProxy", path = RouteParameter.Optional });
        }

        public static void MapTablesProxyServiceRoute(this RouteCollection routes, string prefix)
        {
            routes.MapTablesProxyServiceRoute(prefix, new DelegatingHandler[] { });
        }

        public static void MapTablesProxyServiceRoute(this RouteCollection routes, string prefix, params DelegatingHandler[] handlers)
        {
            var currentConfiguration = GlobalConfiguration.Configuration;

            // Formatters
            currentConfiguration.Formatters.XmlFormatter.SupportedMediaTypes.Add(new MediaTypeHeaderValue("application/atom+xml"));

            // Handlers
            currentConfiguration.AddDelegatingHandlers(handlers);

            // Routes
            routes.MapHttpRoute(
                name: prefix,
                routeTemplate: prefix + "/{*path}",
                defaults: new { Controller = "TablesProxy", path = RouteParameter.Optional });
        }

        public static void MapSasServiceRoute(this RouteCollection routes, string prefix)
        {
            routes.MapSasServiceRoute(prefix, new DelegatingHandler[] { });
        }

        public static void MapSasServiceRoute(this RouteCollection routes, string prefix, params DelegatingHandler[] handlers)
        {
            var currentConfiguration = GlobalConfiguration.Configuration;

            // Handlers
            currentConfiguration.AddDelegatingHandlers(handlers);

            // Routes
            routes.MapHttpRoute(
                name: prefix + "_Containers",
                routeTemplate: prefix + "/containers",
                defaults: new { Controller = "SharedAccessSignature" });

            routes.MapHttpRoute(
                name: prefix + "_Container",
                routeTemplate: prefix + "/containers/{containerName}",
                defaults: new { Controller = "SharedAccessSignature", containerName = RouteParameter.Optional });

            routes.MapHttpRoute(
                name: prefix + "_Blob",
                routeTemplate: prefix + "/blobs/{containerName}/{*blobName}",
                defaults: new { Controller = "SharedAccessSignature" });
        }
    }
}
