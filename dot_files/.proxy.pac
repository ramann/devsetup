function FindProxyForURL(url, host) {
/*  if (dnsResolve("webproxy.internal.max.gov") != null ) {
    return "PROXY webproxy.internal.max.gov:8080";
  }*/

  if ( shExpMatch(host, "eopmail.whca.mil") || shExpMatch(host, "*.max.gov") )  {
    return "PROXY 172.25.13.147:8080";
  }
  return "DIRECT";
}
