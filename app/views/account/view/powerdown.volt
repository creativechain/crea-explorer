<div class="ui three item inverted menu">
  <a href="/@{{ account.name }}/transfers" class="{{ router.getActionName() == 'transfers' ? "active" : "" }} blue item">Transfers</a>
  <a href="/@{{ account.name }}/energize" class="{{ router.getActionName() == 'energize' ? "active" : "" }} blue item">Energizations</a>
  <a href="/@{{ account.name }}/de_energize" class="{{ router.getActionName() == 'de_energize' ? "active" : ""}} blue item">De-Energizations</a>
</div>
<h3 class="ui dividing header">
  De-Energizations
  <div class="sub header">
    The VESTS/CGY of @{{ account.name }} converted to liquid CREA.
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th>When</th>
      <th>From</th>
      <th>To</th>
      <th class="right aligned">VESTS</th>
      <th class="right aligned">CREA</th>
    </tr>
  </thead>
  <tbody>
    {% for power in de_energize %}
    <tr>
      <td>
        <?php echo $this->timeAgo::mongo($power->_ts); ?>
      </td>
      <td>
        <a href="/@{{ power.from_account }}">
          {{ power.from_account }}
        </a>
      </td>
      <td>
        <a href="/@{{ power.to_account }}">
          {{ power.to_account }}
        </a>
      </td>
      <td class="right aligned">
        <div class="ui small header">
          -<?php echo $this->largeNumber::format($power->withdrawn); ?>
        </div>
      </td>
      <td class="right aligned">
        <div class="ui small header">
          +<?php echo $power->deposited; ?> CREA
        </div>
      </td>
    </tr>
  </tbody>
  {% else %}
  <tbody>
    <tr>
      <td colspan="10">
        <div class="ui header">
          No de-energize transfers found
        </div>
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
