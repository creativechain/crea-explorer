{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}

<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <h1 class="ui header offwhite">
      Author Rewards Leaderboard
      <div class="sub header offwhite">
        Total rewards earnings by date and display of the top 500.
      </div>
    </h1>
    <div class="row">
      <div class="column">
        <div class="ui top attached menu">
          {% if grouping %}
          <a href="/labs/author?date={{ date('Y-m', date - 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
            <i class="left arrow icon"></i>
            <span class="mobile hidden">{{ date('Y-m', date - 86400)}}</span>
          </a>
          {% else %}
          <a href="/labs/author?date={{ date('Y-m-d', date - 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
            <i class="left arrow icon"></i>
            <span class="mobile hidden">{{ date('Y-m-d', date - 86400)}}</span>
          </a>
          {% endif %}
          <a class="item" href="/labs/author?date={{ date('Y-m-d')}}">
            Jump to Today
          </a>
          <div class="ui dropdown item">
            {{ (grouping ? grouping : 'Daily') | capitalize }}
            <i class="dropdown icon"></i>
            <div class="menu">
              <a class="{{ grouping == 'daily' ? 'active' : '' }} item" href="/labs/author">
                Daily
              </a>
              <a class="{{ grouping == 'monthly' ? 'active' : '' }} item" href="/labs/author?grouping=monthly">
                Monthly
              </a>
            </div>
          </div>
          <div class="right menu">
            {% if grouping %}
            <?php if(date('Y-m', $date) == date('Y-m')): ?>
            <a class="disabled item">
              <span class="mobile hidden">{{ date('Y-m', date + 86400 * 31)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php else: ?>
            <a href="/labs/author?date={{ date('Y-m', date + 86400 * 31)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
              <span class="mobile hidden">{{ date('Y-m', date + 86400 * 31)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php endif ?>
            {% else %}
              <?php if($date > time() - 86400): ?>
              <a class="disabled item">
                <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
                <i class="right arrow icon"></i>
              </a>
              <?php else: ?>
              <a href="/labs/author?date={{ date('Y-m-d', date + 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
                <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
                <i class="right arrow icon"></i>
              </a>
              <?php endif ?>
            {% endif %}
          </div>
        </div>
        <div class="ui attached basic segment seethrough">
          <div class="ui small center aligned header">
            Totals (based on {{leaderboard | length}} authors)
          </div>
          <div class="ui divided grid">
            <div class="three column row">
              <div class="center aligned column">
                <div class="ui header">
                  {{ totals['crea'] }}
                  <div class="sub header">
                    CREA
                  </div>
                </div>
              </div>
              <div class="center aligned column">
                <div class="ui header">
                  {{ totals['sp'] }}
                  <div class="sub header">
                    CREA Power
                  </div>
                </div>
              </div>
              <div class="center aligned column">
                <div class="ui header">
                  <?php echo $this->largeNumber::format($totals['vest']); ?>
                  <div class="sub header">
                    VEST
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>
        <div class="ui bottom attached segment">
          <div class="ui header">
            Author Leaderboard for
            {% if grouping %}
              {{ date('Y-m', date) }}
            {% else %}
              {{ date('Y-m-d', date) }}
            {% endif %}
            (Displaying Top 500)
            <div class="sub header">
              The accounts earning the highest author rewards by day.
            </div>
          </div>
          <table class="ui celled table">
            <thead>
              <tr>
                <th colspan="2"></th>
                <th colspan="4" class='center aligned'>Total</th>
              </tr>
              <tr>
                <th class="collapsing">#</th>
                <th>Account</th>
                <th class="collapsing center aligned">VESTS/VP</th>
                <th class="collapsing center aligned">CREA</th>
                <th class="collapsing center aligned">Posts</th>
                <th class="collapsing center aligned">VP/Post</th>
              </tr>
            </thead>
            <tbody></tbody>
          {% for account in leaderboard %}
            {% if loop.index > 500 %}{% continue %}{% endif %}
            <tr style="text-align: right">
              <td style="text-align: left">
                #{{ loop.index }}
              </td>
              <td style="width:20%;min-width:100px;max-width:200px;text-align:left">
                <a href="/@{{ account._id }}">
                  {{ account._id }}
                </a>
              </td>
              <td class="right aligned">
                <div class="ui <?php echo $this->largeNumber::color($account->vest)?> label" data-popup data-content="<?php echo number_format($account->vest, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                  <?php echo $this->largeNumber::format($account->vest); ?>
                </div>
                <br>
                <small>
                  ~<?php echo $this->convert::vest2sp($account->vest, ""); ?> VP*
                </small>
              </td>
              <td>
                {{ account.crea }}
              </td>
              <td>
                {{ account.posts }}
              </td>
              <td>
                ~<?php echo $this->convert::vest2sp($account->vest / $account->count, ""); ?>&nbsp;SP*
              </td>
            </tr>
          {% else %}
          <tr>
            <td colspan="10">
              <div class="ui message">
                No data for this date
              </div>
            </td>
          </tr>
          {% endfor %}
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}

{% endblock %}
