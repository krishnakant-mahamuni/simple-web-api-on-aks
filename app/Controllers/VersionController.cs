using System.Net.Http;
using System.Threading.Tasks;
using app.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json.Linq;

namespace simple_web_api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VersionController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public VersionController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("User-Agent",
                    "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)");

                using (var response = await client.GetAsync(_configuration.GetValue<string>("gitUrl")))
                {
                    var json = await response.Content.ReadAsStringAsync();
                    dynamic commits = JArray.Parse(json);
                    var lastCommit = commits[0].sha;

                    var myApplication = new Response
                    {
                        Version = "1.0",
                        lastCommit = lastCommit
                    };

                    return Ok(myApplication);
                }
            }
        }
    }
}