{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui huge dividing header offwhite">
          De-Energize Statistics
          <div class="sub header offwhite">
            Analysis of the accounts currently powering down (using UTC time)
          </div>
        </div>
        <div class="ui small three statistics">
          <div class="statistic">
            <div class="label offwhite">
              Liquid CREA
            </div>
            <div class="value offwhite">
              <?php echo number_format($props['liquid'], 0, ".", ",") ?>
            </div>
          </div>          <div class="statistic">
            <div class="label offwhite">
              Current Supply
            </div>
            <div class="value offwhite">
              <?php echo number_format($props['current'], 0, ".", ",") ?>
            </div>
          </div>
          <div class="statistic">
            <div class="label offwhite">
              Total Vesting Fund
            </div>
            <div class="value offwhite">
              <?php echo number_format($props['vesting'], 0, ".", ",") ?>
            </div>
          </div>

        </div>
        <div class="ui divider"></div>
      </div>
    </div>
    <div class="row">
      <div class="seven wide column">
        <div class="ui centered header offwhite">
          Pending De-Energizations
          <div class="sub header offwhite">
            Total powering down in the next week
          </div>
        </div>
        <table class="ui small striped table">
          <thead>
            <tr>
              <th>Total (Weekly)</th>
              <th class="right aligned"><?php echo number_format($upcoming_total, 0, ".", ",") ?> VESTS</th>
              <th class="right aligned">~<?php echo $this->convert::vest2cgy($upcoming_total, " CREA", 0); ?></th>
            </tr>
          </thead>
          <tbody>
            {% for day in upcoming %}
            <tr>
              <td>
                {{ dow[day['_id']['dow']] }}
                &mdash;
                {{ day['_id']['month'] }}-{{ day['_id']['day'] }}
                {% if loop.index == 1 %}
                  (<strong>Today</strong>)
                {% endif %}
              </td>
              <td class="right aligned"><?php echo number_format($day->withdrawn, 0, ".", ",") ?> VESTS</td>
              <td class="right aligned">~<?php echo $this->convert::vest2cgy($day->withdrawn, " CREA", 0); ?></td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
      <div class="two wide column">
        <div class="ui centered header offwhite">
          Difference
          <div class="sub header offwhite">
            % Change
          </div>
        </div>
        <table class="ui small striped table">
          <thead>
            <th class="right aligned">
              <?php $number = round(($upcoming_total / $previous_total - 1) * 100 ,2); ?>
              {% if number > 0 %}
              <div style="color: #ff5766">
              {% else %}
              <div style="color: #16ab39">
              {% endif %}
                {{ number }}%
              </span>
            </th>
          </thead>
          <tbody>
            {% for idx, day in upcoming %}
            <tr>
              <td class="mobile visible">
                {{ dow[day['_id']['dow']] }}
                &mdash;
                {{ day['_id']['month'] }}-{{ day['_id']['day'] }}
              </td>
              <td class="right aligned">
                <?php
                  $withdrawn = $day['withdrawn'];
                  if($upcoming[8]) {
                    $withdrawn += $upcoming[8]['withdrawn'];
                  }
                  $number = round(($withdrawn / $previous[$idx]['withdrawn'] - 1) * 100, 1);
                 ?>
                {% if number > 0 %}
                <div style="color: #ff5766">
                {% else %}
                <div style="color: #16ab39">
                {% endif %}
                  {{ number }}%
                </span>
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
      <div class="seven wide column">
        <div class="ui centered header offwhite">
          Completed De-Energizations
          <div class="sub header offwhite">
            Total de-energized in the last week
          </div>
        </div>
        <table class="ui small striped table">
          <thead>
            <tr>
              <th>Total</th>
              <th class="right aligned"><?php echo number_format($previous_total, 0, ".", ",") ?> VESTS</th>
              <th class="right aligned">~<?php echo $this->convert::vest2cgy($previous_total, " CREA", 0); ?></th>
            </tr>
          </thead>
          <tbody>
            {% for day in previous %}
            <tr>
              <td>
                {{ dow[day['_id']['dow']] }}
                &mdash;
                {{ day['_id']['month'] }}-{{ day['_id']['day'] }}
              </td>
              <td class="right aligned"><?php echo number_format($day->withdrawn, 0, ".", ",") ?> VESTS</td>
              <td class="right aligned">~<?php echo $this->convert::vest2cgy($day->withdrawn, " CREA", 0); ?></td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
    <div class="row">
      <div class="column">
        <div class="ui divider"></div>
        <div class="ui header offwhite">
          Largest Liquidity Increases
          <div class="sub header offwhite">
            30 days worth of de-energizes combined per account
          </div>
        </div>
        <table class="ui small striped attached table">
          <thead>
            <tr>
              <th></th>
              <th class="right aligned">CREA Deposited</th>
              <th class="right aligned">Vests Withdrawn</th>
              <th>Vests Remaining</th>
              <th>Account Withdrawing</th>
              <th>Account(s) Receiving</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {% for de_energize in de_energizes %}
            <tr>
              <td class="collapsing">{{ loop.index }}</td>
              <td class="collapsing right aligned">
                <div class="ui header">
                  +<?php echo $this->largeNumber::format($de_energize->deposited, '', " CREA", 0); ?>
                  <div class="sub header">
                    {{ de_energize.count }}x De-Energizations
                  </div>
                </div>
              </td>
              <td class="collapsing right aligned">
                <div class="ui <?php echo $this->largeNumber::color($de_energize->withdrawn)?> label" data-popup data-content="<?php echo number_format($de_energize->withdrawn, 0, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                  -<?php echo $this->largeNumber::format($de_energize->withdrawn); ?>
                </div>
              </td>
              <td class="collapsing right aligned">
                {{ partial("_elements/vesting_shares", ['current': de_energize.account[0]]) }}
              </td>
              <td>
                <div class="ui header">
                  <div class="ui circular blue label">
                    <?php echo $this->reputation::number($de_energize->account[0]->reputation) ?>
                  </div>
                  {{ link_to("/@" ~ de_energize.account[0].name, de_energize.account[0].name) }}
                  <div class="sub header" style="margin-left: 50px">
                    <a href="/@{{ de_energize.account[0].name }}/de_energize">
                      De-Energizations
                    </a>
                    |
                    <a href="/@{{ de_energize.account[0].name }}/transfers">
                      Transfers
                    </a>
                  </div>
                </div>
              </td>
              <td>
                <div class="ui list">
                {% for account in de_energize.deposited_to %}
                  <div class="item">
                    <a href="/@{{ account }}">
                      {{ account }}
                    </a>
                  </div>
                {% endfor %}
                </div>
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
{% endblock %}
