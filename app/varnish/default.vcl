vcl 4.1;

# Guide for VCL 4.0
# https://varnish-cache.org/docs/trunk/whats-new/upgrading-4.0.html
# https://www.varnish-software.com/wiki/content/tutorials/varnish/sample_vclTemplate.html
# https://github.com/mattiasgeniar/varnish-4.0-configuration-templates/

# Reference
# https://varnish-cache.org/docs/trunk/reference/vcl.html
# https://varnish-cache.org/docs/trunk/reference/vcl-var.html

import std;
import cookie;
import uuid;

backend default {
  .host = "www";
  .port = "3000";
}

sub vcl_recv {
  set req.url = std.querysort(req.url);

  if (req.http.cookie) {
    cookie.parse(req.http.cookie);
  }

  if (req.url ~ "^/\.") {
    # e.g. "/.bundles", "/.assets", "/.synth"
    set req.http.x-is-special-path = true;
  }

  if (req.url ~ "/.synth/hello") {
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
  unset resp.http.via;
  unset resp.http.x-varnish;

  set resp.http.x-shqld = "Hello from @shqld";

  if (!req.http.x-is-special-path && !cookie.get("__Secure-id")) {
    # 'Domain' should not be set in a basic way to prevent unintended subdomains to be included, but I set here intentionally
    set resp.http.set-cookie = "__Secure-id=" + uuid.uuid_v4() + "; Max-Age=31556952; HttpOnly; Secure; SameSite=None; Domain=shqld.dev;";
  }
}
