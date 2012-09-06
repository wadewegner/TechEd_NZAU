using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Web.Controllers
{
    public class BeerController : ApiController
    {
        // GET api/beer
        public IEnumerable<string> Get()
        {
            return new string[] { "Dogberry Pale Ale", "White Lady Witbier", "Gold Rush", "Element 5", "Custom 69", "Razzmatazz" };
        }

        // GET api/beer/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/beer
        public void Post([FromBody]string value)
        {
        }

        // PUT api/beer/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/beer/5
        public void Delete(int id)
        {
        }
    }
}
