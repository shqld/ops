backend me {
  .host = "me";
  .port = "3000";
}

sub me_recv {
  if (req.http.host == "me.shqld.dev") {
    # FIXME: move the value inside of the private repo (me.shqld.dev)
    if (req.http.Authorization != "Basic c2hxbGQ6bGFsYQ==") {
      return (synth(401));
    }

    set req.backend_hint = me;
  }
}


sub me_synth {
  if (req.http.host == "me.shqld.dev" && resp.status == 401) {
      set resp.http.WWW-Authenticate = {"Basic realm="Authorization Required""};
      return(deliver);
  }
}
