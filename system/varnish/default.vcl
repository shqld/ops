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

include "chunks/example.vcl";

backend default {
  .host = "www";
  .port = "3000";
}
backend me {
  .host = "me";
  .port = "3001";
}

sub vcl_recv {
  set req.url = std.querysort(req.url);

  if (req.http.cookie) {
    cookie.parse(req.http.cookie);
  }

  call example_recv;

  if (req.url ~ "^/\.") {
    # e.g. "/.bundles", "/.assets", "/.synth"
    set req.http.x-is-special-path = true;
  }

  if (req.url ~ "/.synth/hello") {
    return (synth(800, "Hello World"));
  }

  if (req.http.host == "me.shqld.dev") {
    # FIXME: move the value inside of the private repo (me.shqld.dev)
    if (req.http.Authorization != "Basic c2hxbGQ6bGFsYQ==") {
      return (synth(401));
    }

    set req.backend_hint = me;
  }
}

sub vcl_hash {
  call example_hash;
}

sub vcl_synth {
    if (resp.status == 800) {
        set resp.status = 200;
        set resp.http.Content-Type = "text/html; charset=utf-8";
        synthetic("<h1>Hello World</h1>");
        return (deliver);
    } else if (req.http.host == "me.shqld.dev" && resp.status == 401) {
        set resp.http.WWW-Authenticate = {"Basic realm="Authorization Required""};
        return(deliver);
    }

    call example_synth;
}

sub vcl_hit {
  call example_hit;
}
sub vcl_miss {
  call example_miss;
}
sub vcl_pass {
  call example_pass;
}

sub vcl_backend_fetch {
  call example_backend_fetch;
}
sub vcl_backend_response {
  call example_backend_response;
}
sub vcl_backend_error {
  call example_backend_error;
}

sub vcl_purge {
  call example_purge;
}
sub vcl_pipe {
  call example_pipe;
}

sub vcl_deliver {
  unset resp.http.via;
  unset resp.http.x-varnish;

  set resp.http.x-shqld = "Hello from @shqld";

  call example_deliver;

  if (!req.http.x-is-special-path && !cookie.get("__Secure-id")) {
    # 'Domain' should not be set in a basic way to prevent unintended subdomains to be included, but I set here intentionally
    set resp.http.set-cookie = "__Secure-id=" + uuid.uuid_v4() + "; Max-Age=31556952; HttpOnly; Secure; SameSite=None; Domain=shqld.dev;";
  }
}
