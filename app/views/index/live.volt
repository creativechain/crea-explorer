
<!DOCTYPE html>
<html>
   <head>
      <script type="text/javascript">
         var sock = null;
         var ellog = null;

         window.onload = function() {

            var wsuri = "wss://nodes.creary.net";
            ellog = document.getElementById('log');

            if ("WebSocket" in window) {
               sock = new WebSocket(wsuri);
            } else if ("MozWebSocket" in window) {
               sock = new MozWebSocket(wsuri);
            } else {
               log("Browser does not support WebSocket!");
            }

            if (sock) {
               sock.onopen = function() {
                  log("Connected to " + wsuri);
               }

               sock.onclose = function(e) {
                  log("Connection closed (wasClean = " + e.wasClean + ", code = " + e.code + ", reason = '" + e.reason + "')");
                  sock = null;
               }

               sock.onmessage = function(e) {
                  var data = JSON.parse(e.data);
                  log(JSON.stringify(data));
               }
            }
         };

         function broadcast() {
            var account = document.getElementById('account').value;
            if (sock) {
               sock.send(account);
               log("Subscribed account: " + account);
            } else {
               log("Not connected.");
            }
         };

         function log(m) {
             if (ellog) {
                 ellog.innerHTML += m + '\n';
                 ellog.scrollTop = ellog.scrollHeight;
             } else {
                 console.log(m);
             }
         };
      </script>
   </head>
   <body>
      <form>
        <p>
          Subscribe to account
          <input id="account" type="text" size="50" maxlength="50" value="@jesta">
        </p>
      </form>
      <button onclick='broadcast();'>Subscribe</button>
      <pre id="log" style="height: 20em; overflow-y: scroll; background-color: #faa;"></pre>
   </body>
</html>
