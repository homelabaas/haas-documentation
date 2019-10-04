# Mini DNS

Mini DNS is a small API driven DNS server, which, under the covers, just runs Bind. It is most useful for serving up private DNS queries for a private network. If you configure all your servers to point to MiniDNS for DNS resolution, Mini DNS will then forward on queries to your normal DNS servers if it can't resolve the names.

You can interact with this server via it's API to manage DNS zones and DNS records. The API is very simple, and provides very basic functionality.

## Installation

Run the dns-api docker image, and expose both the DNS endpoint on port 53 UDP, and the the HTTP API endpoint. An example of this is:

```docker run -d -p 53:53/udp -p 8080:80 homelabaas/dns-api```

Access the API documentation on <http://localhost:8080/docs>, or interact with the API at <http://localhost:8080/api>.

## Use

For interation with the API, there is a swagger specification provided. The latest swagger specification can always be found at: <https://raw.githubusercontent.com/homelabaas/dns-api/master/src/api/swagger.yaml>

Mini DNS will also run the swagger documentation available at `/docs`. For example, if you run the container on localhost and expose the API on port 8080, swagger documentation will be avilable on <http://localhost:8080/docs>.

## How it works

Mini DNS stored zone and record configuration information, and this information can be modified by calling the API. In the background, Mini DNS just runs bind to serve all the DNS queries.

When the DNS configuration is changed in any way, Mini DNS re-generates a set of config files for Bind, and then tells Bind to reload the configuration.

The configuration files are just mustache templates, which get populated by the API when required.

## Diagnosing Issues

The logs should also include the logs from Bind, prefixed with `bind_stderr` or `bind_stdout`. It is possible to write out configuration files that Bind does not load, and the logs will indicate when Bind is having an issue as well.
