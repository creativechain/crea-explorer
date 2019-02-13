<div class="ui three item inverted menu">
  <a href="/@{{ account.name }}/transfers" class="{{ router.getActionName() == 'transfers' ? "active" : "" }} blue item">Transfers</a>
  <a href="/@{{ account.name }}/energize" class="{{ router.getActionName() == 'energize' ? "active" : "" }} blue item">Energizations</a>
  <a href="/@{{ account.name }}/de_energize" class="{{ router.getActionName() == 'de_energize' ? "active" : ""}} blue item">De-Energizations</a>
</div>
<h3 class="ui dividing header">
  Energizations
  <div class="sub header">
    The CREA energized to @{{ account.name }}.
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th>When</th>
      <th>From</th>
      <th>To</th>
      <th class="right aligned">CREA</th>
    </tr>
  </thead>
  <tbody>
    {% for power in energize %}
    <tr>
      <td>
        <?php echo $this->timeAgo::mongo($power->_ts); ?>
      </td>
      <td>
        <a href="/@{{ power.from }}">
          {{ power.from }}
        </a>
      </td>
      <td>
        <a href="/@{{ power.to }}">
          {{ power.to }}
        </a>
      </td>
      <td class="right aligned">
        {{ power.amount }} CREA
      </td>
    </tr>
  </tbody>
  {% else %}
  <tbody>
    <tr>
      <td colspan="10">
        <div class="ui header">
          No energize transfers found
        </div>
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
