using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;
using System.Threading;
using System.Web;
using Web.FederatedIdentity.Infrastructure;

namespace Web
{
    public class TokenValidationHandler : DelegatingHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            string authHeader = string.Empty;

            if (request.Headers != null)
            {
                if (request.Headers.Authorization != null)
                {
                    authHeader = request.Headers.GetValues("Authorization").First();
                }
            }

            string header = "OAuth ";
            string token = string.Empty;

            if (string.CompareOrdinal(authHeader, 0, header, 0, header.Length) == 0)
            {
                token = authHeader.Remove(0, header.Length);

                var validator = new SimpleWebTokenValidator
                    {
                        SharedKeyBase64 = "YOURSHAREDSECRET"
                    };

                var swt = validator.ValidateToken(token);
            }
            else
            {
                throw new HttpException((int)System.Net.HttpStatusCode.Unauthorized, "The authorization header was invalid");
            }

            return base.SendAsync(request, cancellationToken);
        }
    }
}
