# https://varnish-cache.org/docs/trunk/whats-new/upgrading-4.0.html
# https://www.varnish-software.com/wiki/content/tutorials/varnish/sample_vclTemplate.html
# https://github.com/mattiasgeniar/varnish-4.0-configuration-templates/

vcl 4.1;

backend default {
  .host = "www";
  .port = "3000";
}

sub vcl_recv {
  if (req.url ~ "/.vcl/synthetic/hello") {
      return (synth(800, "Hello World"));
  }
}

sub vcl_backend_response {
}

sub vcl_synth {
    if (resp.status == 800) {
        set resp.status = 200;
        set resp.http.Content-Type = "text/html; charset=utf-8";
        synthetic("<h1>Hello World</h1>");
        return (deliver);
    }
}

sub vcl_deliver {
  set resp.http.x-shqld = "Hello from @shqld";
}
