{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui huge header offwhite">
          Accounts
          <div class="sub header offwhite">
            Accounts sorted by various metrics
          </div>
        </div>
        <div class="ui top attached menu">
          <div class="ui dropdown item">
            Richlist
            <i class="dropdown icon"></i>
            <div class="menu">
              <a class="{{ filter == 'vest' ? 'active' : '' }} item" href="/accounts/vest">
                Vests/CGY
              </a>
              <a class="{{ filter == 'vit' ? 'active' : '' }} item" href="/accounts/vit">
                CREA
              </a>
              <a class="{{ filter == 'de_energize' ? 'active' : '' }} item" href="/accounts/de_energize">
                De-Energize
              </a>
            </div>
          </div>
          <a class="{{ filter == 'posts' ? 'active' : '' }} item" href="/accounts/posts">
            Posts
          </a>
          <div class="ui dropdown item">
            Social
            <i class="dropdown icon"></i>
            <div class="menu">
              <a class="{{ filter == 'followers' ? 'active' : '' }} item" href="/accounts/followers">
                Followers
              </a>
              <a class="{{ filter == 'followers_mvest' ? 'active' : '' }} item" href="/accounts/followers_mvest">
                Value of Followers
              </a>
            </div>
          </div>
          <a class="{{ filter == 'reputation' ? 'active' : '' }} item" href="/accounts/reputation">
            Reputation
          </a>
          <div class="right menu">
            <div class="item">
              Data updated <?php echo $this->timeAgo::mongo($accounts[0]->scanned); ?>
            </div>
          </div>
        </div>
        <table class="ui attached table seethrough">
          <thead>
            <tr>
              <th>Account</th>
              <th class="center aligned">Followers</th>
              <th class="center aligned">Posts</th>
              <th class="right aligned">Vests</th>
              <th class="right aligned">De-energize</th>
              <th class="right aligned">Balances</th>
            </tr>
          </thead>
          <tbody>
            {% for account in accounts %}
            <tr>
              <td>
                <div class="ui header">
                  <div class="ui circular blue label">
                    <?php echo $this->reputation::number($account->reputation) ?>
                  </div>
                  {{ link_to("/@" ~ account.name, account.name) }}
                </div>
              </td>
              <td class="collapsing center aligned">
                <div class="ui small header">
                  {{ account.followers_count }}
                  <div class="sub header">
                    <?php echo $this->largeNumber::format($account->followers_mvest); ?>
                  </div>
                </div>
              </td>
              <td class="collapsing center aligned">
                {{ account.post_count }}
              </td>
              <td class="collapsing right aligned">
                {{ partial("_elements/vesting_shares", ['current': account]) }}
              </td>
              <td class="collapsing right aligned">
                <?php if(is_numeric($account->vesting_withdraw_rate) && $account->vesting_withdraw_rate > 0.01): ?>
                  <div data-popup data-content="<?php echo number_format($current->vesting_withdraw_rate, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                    <?php echo $this->largeNumber::format($current->vesting_withdraw_rate); ?> (<?php echo round($current->vesting_withdraw_rate / $current->vesting_shares * 100, 2) ?>%)
                  </div>
                  +<?php echo $this->convert::vest2cgy($current->vesting_withdraw_rate); ?>/Week
                <?php endif; ?>
              </td>
              <td class="collapsing right aligned">
                <div class="ui small header">
                  <?php echo number_format($account->total_balance, 3, ".", ",") ?> CREA
                </div>
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
    <div class="row">
      <div class="column">
        {% include "_elements/paginator.volt" %}
      </div>
    </div>
  </div>
</div>
{% endblock %}
