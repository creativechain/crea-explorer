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
  <div class="ui stackable grid">
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
  <div class="six wide centered column" style="margin-top: 0px">
    <div class="ui small dividing header offwhite">
      Metrics
      <div class="sub header offwhite">
        Global properties and statistics
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

      var wsuri = "wss://nodes.creary.net";
      ellog = document.getElementById('log');

      if ("WebSocket" in window) {
        sock = new WebSocket(wsuri);
      } else if ("MozWebSocket" in window) {
        sock = new MozWebSocket(wsuri);
      } else {
        //  log("Browser does not support WebSocket!");
      }


      if (sock) {

        var data = {};
        var lastBlock = {{ props['last_irreversible_block_num'] }};
        var getState = function () {
          //Dynamic global properties
          sock.send(JSON.stringify({
            jsonrpc:"2.0",
            method:"database_api.get_dynamic_global_properties",
            params: {},
            id: parseInt(Math.random() * (Number.MAX_SAFE_INTEGER - 1) + 1)
          }));

          //Witness Schedule
          sock.send(JSON.stringify({
            jsonrpc:"2.0",
            method: "condenser_api.get_witness_schedule",
            params:[],
            "id": parseInt(Math.random() * (Number.MAX_SAFE_INTEGER - 1) + 1)
          }))

          //Feed price
          /*sock.send(JSON.stringify({
            jsonrpc:"2.0",
            method: "database_api.get_feed_history",
            id: parseInt(Math.random() * (Number.MAX_SAFE_INTEGER - 1) + 1)
          }));*/
        };

        var getBlock = function(blockNum) {
          lastBlock = blockNum;
          sock.send(JSON.stringify({
            jsonrpc:"2.0",
            method:"block_api.get_block",
            params: {block_num: blockNum},
            id: parseInt(Math.random() * (Number.MAX_SAFE_INTEGER - 1) + 1)
          }))
        };

        sock.onopen = function() {
          console.log("Connected to " + wsuri);
        }

        sock.onclose = function(e) {
          // log("Connection closed (wasClean = " + e.wasClean + ", code = " + e.code + ", reason = '" + e.reason + "')");
          sock = null;
        }

        sock.onmessage = function(e) {
          var result = JSON.parse(e.data).result;
          data.props = result.last_irreversible_block_num ? result : null;
          data.witness_schedule = result.median_props ? result : null;
          data.feed_price = result.current_median_history ? result.current_median_history : null;
          data.block = result.block ? result.block : null;

          if(data.props) {
            if (data.props.last_irreversible_block_num !== lastBlock) {
              getBlock(data.props.last_irreversible_block_num);
            }

            $.each(data.props, function(key, value) {
              if (data.props[key]['nai']) {
                value = Asset.parse(data.props[key]).toFriendlyString(null, false);
              }

              $("[data-props="+key+"]").html(value);
            });
          }
          if (data.witness_schedule) {
            $.each(data.witness_schedule, function(key, value) {
              $("[data-state-witness="+key+"]").html(value);
            });
            $.each(data.witness_schedule.median_props, function(key, value) {
              $("[data-state-witness-median="+key+"]").html(value);
            });
          }

          if (data.feed_price) {
            $.each(data.feed_price, function(key, value) {
              if (data.feed_price[key]['nai']) {
                value = Asset.parse(data.feed_price[key]).toFriendlyString(null, false);
              }
              $("[data-state-feed="+key+"]").html(value);
            });
          }


          if(data.block) {
            var tbody = $("#blocks-table-body"),
                    row = $("<tr class='block-animation'>"),
                    rows = tbody.find("tr"),
                    rowLimit = 25,
                    count = rows.length,
                    // Block Height
                    height_header = $("<div class='ui small header'>"),
                    height_header_link = $("<a>").attr("href", "/block/" + lastBlock).attr("target", "_blank").html("#"+lastBlock),
                    height_header_time = $("<div class='sub header'>").html(data.block.timestamp),
                    height = $("<td>").append(height_header.append(height_header_link, height_header_time)),
                    // Transactions
                    tx = $("<td>").append(data.block.transactions.length),
                    ops = $("<td>");

            var opCount = {};
            data.block.transactions.forEach(function (t) {
              t.operations.forEach(function (o) {
                if (opCount[o.type]) {
                  opCount[o.type]++
                } else {
                  opCount[o.type] = 1;
                }
              })
            })

            $.each(opCount, function(key, value) {
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

        setInterval(function () {
          getState();
        }, 3000)
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
