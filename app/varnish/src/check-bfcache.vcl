sub check_bfcache_recv {
  if (req.url ~ "^/.labs/bfcache") {
    return (synth(801));
  }
}

sub check_bfcache_synth {
  if (resp.status == 801) {
    set resp.status = 200;
    set resp.http.Content-Type = "text/html; charset=utf-8";
    synthetic({"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset=UTF-8>
  <title>check bfcache behavior</title>
</head>
<body>
  <script>
    const status = document.querySelector('.status')
    status.innerHTML = '<p>Rendering... <span class=counter></span>%</p>'

    const counter = document.querySelector('.counter')

    function loop(i) {
      counter.textContent = i
      if (i === 100) {
        status.textContent = 'Done'
        return
      }
      requestAnimationFrame(() => {
        loop(i + 1)
      })
    }

    loop(0)
  </script>
  <h1>Check bfcache behavior</h1>
  <p>Counter</p>
  <p class=status>Loading...</p>
</body>
</html>
    "});
    return(deliver);
  }
}
