<h3 class="ui header">
  Author Rewards for {{ date }}
  <div class="sub header">
    The rewards @{{ account.name }} has earned from posting on {{ date }}
  </div>
</h3>
<a href="/@{{ account.name }}/authoring{{ filter != null ? '?filter=' ~ filter : '' }}" class="ui primary icon button">
  <i class="left chevron icon"></i>
  Back to All Dates
</a>
<div class="ui divider"></div>
<a href="/@{{ account.name }}/authoring/{{ date }}" class="ui tiny {{ filter == null ? 'blue' : '' }} basic button">All</a>
<a href="/@{{ account.name }}/authoring/{{ date }}?filter=posts" class="ui tiny {{ filter == 'posts' ? 'blue' : '' }} basic button">Only Posts</a>
<a href="/@{{ account.name }}/authoring/{{ date }}?filter=comments" class="ui tiny {{ filter == 'comments' ? 'blue' : '' }} basic button">Only Comments</a>

{% for reward in authoring %}
  {% if reward._ts.toDateTime().format("Ymd") != date %}
    {% if date != null %}
      </tbody>
    </table>
    {% endif %}
    <div class="ui header">
      {{ reward._ts.toDateTime().format("Y-m-d") }}
      {% set date = reward._ts.toDateTime().format("Ymd") %}
    </div>
    <table class="ui striped table">
      <thead>
        <tr>
          <th>Content</th>
          <th class="collapsing right aligned">CBD</th>
          <th class="collapsing right aligned">CREA</th>
          <th class="collapsing right aligned">CGY</th>
          <th class="collapsing right aligned">VEST</th>
        </tr>
      </thead>
      <tbody class="infinite-scroll">
  {% endif %}
        <tr>
          <td>
            <a href="/tag/@{{ reward.author }}/{{ reward.permlink }}">
              {{ reward.permlink }}
            </a>
            <br>
            <?php echo $this->timeAgo::mongo($reward->_ts); ?>
          </td>
          <td class="collapsing right aligned">
            <?php echo $this->largeNumber::format($reward->cbd_payout); ?> CBD
          </td>
          <td class="collapsing right aligned">
            <?php echo $this->largeNumber::format($reward->crea_payout); ?> CREA
          </td>
          <td class="collapsing right aligned">
            ~<?php echo $this->convert::vest2cgy($reward->vesting_payout, ""); ?> CGY*
          </td>
          <td class="collapsing right aligned">
            <div class="ui <?php echo $this->largeNumber::color($reward->vesting_payout)?> label" data-popup data-content="<?php echo number_format($reward->vesting_payout, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
              <?php echo $this->largeNumber::format($reward->vesting_payout); ?>
            </div>
          </td>
        </tr>
{% else %}
        <tr>
          <td colspan="10">
            <div class="ui header">
              No author rewards found
            </div>
          </td>
        </tr>
{% endfor %}
      </tbody>
    </table>
{% include "_elements/paginator.volt" %}
