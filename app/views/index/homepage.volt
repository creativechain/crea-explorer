{% extends 'layouts/homepage.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<style>
.block-animation {
  background-color:red;
  animation: loadin 1s forwards;
  background-color:rgba(105, 205, 100, 1);
}
@keyframes loadin {
    from {background-color:rgba(105, 205, 100, 1);}
    to {background-color:rgba(105, 205, 100, 0);}
}
</style>

<div class="ui body container">
  <h1 class="ui header offwhite">
    CREAdb
    <div class="sub header offwhite">
      Block explorer and database for the CREA blockchain.
    </div>
  </h1>
  <div class="ui stackable grid">
    <div class="row">
      <div class="four wide column centered">
        <!-- TradingView Widget BEGIN
        <script type="text/javascript" src="https://d33t3vvu2t2yu5.cloudfront.net/tv.js"></script>
        <script type="text/javascript">
        new TradingView.widget({
          "autosize": true,
          "symbol": "HITBTC:BTCCREA",
          "interval": "120",
          "timezone": "Etc/UTC",
          "theme": "White",
          "style": "1",
          "locale": "en",
          "toolbar_bg": "#f1f3f6",
          "enable_publishing": false,
          "hide_top_toolbar": true,
          "allow_symbol_change": true,
          "hideideas": true
        });
        </script>
        TradingView Widget END -->
      </div>
    </div>
    <div class="row">
      <div class="ten wide column">
        {% if (renderChart > 0) %}
          <div class="ui small dividing header offwhite">
            {#<a class="ui tiny blue basic button" href="/stats" style="float:right">
              View more details
            </a>#}
            30-Day MVest Distribution
            <div class="sub header offwhite">
              Distribution of stake by the blockchain through various channels over 30 days.
            </div>
          </div>
          <div class="ui horizontal stacked segments">
            <div class="ui center aligned segment">
              <div class="ui <?php echo $this->largeNumber::color($totals['curation'])?> label" data-popup data-content="<?php echo number_format($totals['curation'], 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                <?php echo $this->largeNumber::format($totals['curation']); ?>
              </div>
              <div class="ui small header" style="margin-top: 0.5em;">
                <?php echo round($totals['curation'] / array_sum($totals) * 100, 1) ?>%<br>
                <a href="/labs/curation?grouping=monthly">
                  <small>Curation</small>
                </a>
              </div>
            </div>
            <div class="ui center aligned segment">
              <div class="ui <?php echo $this->largeNumber::color($totals['author_rewards']['posts'])?> label" data-popup data-content="<?php echo number_format($totals['author_rewards']['posts'], 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                <?php echo $this->largeNumber::format($totals['author_rewards']['posts']); ?>
              </div>
              <div class="ui small header" style="margin-top: 0.5em;">
                <?php echo round($totals['author_rewards']['posts'] / array_sum($totals) * 100, 1) ?>%<br>
                <a href="/labs/author">
                  <small>Authors</small>
                </a>
              </div>
            </div>
            {#<div class="ui center aligned segment">
              <div class="ui <?php echo $this->largeNumber::color($totals['author_rewards']['replies'])?> label" data-popup data-content="<?php echo number_format($totals['author_rewards']['replies'], 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                <?php echo $this->largeNumber::format($totals['author_rewards']['replies']); ?>
              </div>
              <div class="ui small header" style="margin-top: 0.5em;">
                <?php echo round($totals['author_rewards'][0] / array_sum($totals) * 100, 1) ?>%<br>
                <a href="/labs/author">
                  <small>Commenters</small>
                </a>
              </div>
            </div>#}
            <div class="ui center aligned segment">
              <div class="ui <?php echo $this->largeNumber::color($totals['interest'])?> label" data-popup data-content="<?php echo number_format($totals['interest'], 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                <?php echo $this->largeNumber::format($totals['interest']); ?>
              </div>
              <div class="ui small header" style="margin-top: 0.5em;">
                <?php echo round($totals['interest'] / array_sum($totals) * 100, 1) ?>%<br>
                <a href="/accounts">
                  <small>Interest</small>
                </a>
              </div>
            </div>
            <div class="ui center aligned segment">
              <div class="ui <?php echo $this->largeNumber::color($totals['witnesses'])?> label" data-popup data-content="<?php echo number_format($totals['witnesses'], 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                <?php echo $this->largeNumber::format($totals['witnesses']); ?>
              </div>
              <div class="ui small header" style="margin-top: 0.5em;">
                <?php echo round($totals['witnesses'] / array_sum($totals) * 100, 1) ?>%<br>
                <a href="/witnesses">
                  <small>Witnesses</small>
                </a>
              </div>
            </div>
          </div>
        {% endif %}

        <div class="ui small dividing header offwhite">
          <a class="ui tiny blue button" href="/blocks" style="float:right">
            View more blocks
          </a>
          Recent Blockchain Activity
          <div class="sub header offwhite">
            Displaying most recent irreversible blocks.
          </div>
        </div>
        <div class="ui grid">
          <div class="two column row">
            <div class="column">
              <span class="ui horizontal blue basic label" data-props="head_block_number">
                {{  props['head_block_number'] }}
              </span>
              Current Height
            </div>
            <div class="column">
              <span class="ui horizontal orange basic label" data-props="reversible_blocks">
                {{ props['head_block_number'] - props['last_irreversible_block_num'] }}
              </span>
              Reversable blocks awaiting consensus
            </div>
          </div>
        </div>
        <table class="ui small table" id="blockchain-activity">
          <thead>
            <tr>
              <th>Height</th>
              <th>Transactions</th>
              <th>Operations</th>
            </tr>
          </thead>
          <tbody id="blocks-table-body">
            <tr class="loading center aligned">
              <td colspan="10">
                <div class="ui very padded basic segment">
                  <div class="ui active centered inline loader"></div>
                  <div class="ui header">
                    Waiting for new irreversible blocks
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="six wide centered column">
        <div id="hitbtc-ticker" class="hit-medium" style=";width:275px;height:160px;" data-hue="93"></div>
        <script type="text/javascript">
            (function() {
                var po = document.createElement("script");
                po.type = "text/javascript";
                po.async = true;
                po.src = "https://hitbtc.com/get_widget?pair=vitusd";
                var s = document.getElementsByTagName("script")[0];
                s.parentNode.insertBefore(po, s);
            })();
        </script>
        <div class="ui small dividing header offwhite">
          Metrics
          <div class="sub header offwhite">
            Witness Parameters, global properties and statistics
          </div>
        </div>
        <div class="ui horizontal stacked segments">
          <div class="ui center aligned segment">
            <div class="ui tiny statistic">
              <div class="value" data-props="crea_per_mvests">
                {{ props['crea_per_mvests'] }}
              </div>
              <div class="label">
                CREA per MVest
              </div>
            </div>
          </div>
        </div>
        <div class="ui divider"></div>
        <div class="ui small header offwhite">
          Network Performance
        </div>
        <table class="ui small definition table" id="state">
          <tbody>
            <tr>
              <td class="eight wide">Transactions per second (24h)</td>
              <td>
                {{ tx_per_sec }} tx/sec
              </td>
            </tr>
            <tr>
              <td class="eight wide">Transactions per second (1h)</td>
              <td>
                {{ tx1h_per_sec }} tx/sec
              </td>
            </tr>
            <tr>
              <td>Transactions over 24h</td>
              <td>
                {{ tx }} txs
              </td>
            </tr>
            <tr>
              <td>Transactions over 1h</td>
              <td>
                {{ tx1h }} txs
              </td>
            </tr>
            <tr>
              <td>Operations over 24h</td>
              <td>
                {{ op }} ops
              </td>
            </tr>
            <tr>
              <td>Operations over 1h</td>
              <td>
                {{ op1h }} ops
              </td>
            </tr>
          </tbody>
        </table>
        <div class="ui small header offwhite">
          Consensus State
        </div>
        <table class="ui small definition table" id="state">
          <tbody>
            <tr>
              <td class="eight wide">CREA Inflation Rate</td>
              <td>
                {{ inflation }}
              </td>
            </tr>
            <tr>
              <td class="eight wide">Account Creation Fee</td>
              <td>
                <span data-state-witness-median="account_creation_fee">
                  <i class="notched circle loading icon"></i>
                </span>
              </td>
            </tr>
            <tr>
              <td>Maximum Block Size</td>
              <td>
                <span data-state-witness-median="maximum_block_size">
                  <i class="notched circle loading icon"></i>
                </span>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="ui small header offwhite">
          Reward Pool
        </div>
        <table class="ui small definition table" id="global_props">
          <tbody>
            {% for key, value in funds %}
              {% if key not in ['_id', 'id', 'name'] %}
                <tr>
                  <td class="eight wide">{{ key }}</td>
                  <td data-props="{{ key }}">{{ value }}</td>
                </tr>
              {% endif %}
            {% endfor %}
          </tbody>
        </table>
        <div class="ui small header offwhite">
          Global Properties
        </div>
        <table class="ui small definition table" id="global_props">
          <tbody>
            {% for key, value in props %}
              {% if key not in ['id', 'crea_per_mvests', 'head_block_id', 'recent_slots_filled', 'head_block_number'] %}
                <tr>
                  <td class="eight wide">{{ key }}</td>
                  <td data-props="{{ key }}">{{ value }}</td>
                </tr>
              {% endif %}
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>


{% endblock %}

{% block scripts %}
<script type="text/javascript">
   var sock = null;
   var ellog = null;

   window.onload = function() {

      var wsuri = "wss://node1.creary.net/ws/";
      ellog = document.getElementById('log');

      if ("WebSocket" in window) {
         sock = new WebSocket(wsuri);
      } else if ("MozWebSocket" in window) {
         sock = new MozWebSocket(wsuri);
      } else {
        //  log("Browser does not support WebSocket!");
      }


      if (sock) {
         sock.onopen = function() {
            log("Connected to " + wsuri);
         }

         sock.onclose = function(e) {
            // log("Connection closed (wasClean = " + e.wasClean + ", code = " + e.code + ", reason = '" + e.reason + "')");
            sock = null;
         }

         sock.onmessage = function(e) {
            var data = JSON.parse(e.data);
            log(data);
            if(data.props) {
              $.each(data.props, function(key, value) {
                $("[data-props="+key+"]").html(value);
              });
            }
            if(data.state) {
              $.each(data.state.witness_schedule, function(key, value) {
                $("[data-state-witness="+key+"]").html(value);
              });
              $.each(data.state.witness_schedule.median_props, function(key, value) {
                $("[data-state-witness-median="+key+"]").html(value);
              });
              $.each(data.state.feed_price, function(key, value) {
                $("[data-state-feed="+key+"]").html(value);
              });
            }
            if(data.block) {
              var tbody = $("#blocks-table-body"),
                  row = $("<tr class='block-animation'>"),
                  rows = tbody.find("tr"),
                  rowLimit = 19,
                  count = rows.length,
                  // Block Height
                  height_header = $("<div class='ui small header'>"),
                  height_header_link = $("<a>").attr("href", "/block/" + data.block.height).attr("target", "_blank").html("#"+data.block.height),
                  height_header_time = $("<div class='sub header'>").html(data.block.ts),
                  height = $("<td>").append(height_header.append(height_header_link, height_header_time)),
                  // Transactions
                  tx = $("<td>").append(data.block.opCount),
                  ops = $("<td>");
              $.each(data.block.opCounts, function(key, value) {
                var label = $("<span class='ui tiny basic label'>").append(key + " (" + value + ")");
                ops.append(label);
              });
              tbody.find("tr.loading").remove();
              row.append(height, tx, ops);
              tbody.prepend(row);
              if(count > rowLimit) {
                rows.slice(rowLimit-count).remove();
              }
            }
            // log(JSON.stringify(data));
         }
      }
   };

  //  function broadcast() {
  //     var account = document.getElementById('account').value;
  //     if (sock) {
  //        sock.send(account);
  //        log("Subscribed account: " + account);
  //     } else {
  //        log("Not connected.");
  //     }
  //  };

   function log(m) {
     if (ellog) {
       ellog.innerHTML += m + '\n';
       ellog.scrollTop = ellog.scrollHeight;
     } else {
       console.log(m);
     }

   };
</script>
{% endblock %}
