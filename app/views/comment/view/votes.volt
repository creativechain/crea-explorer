<table class="ui unstackable table" id="table-votes">
  <thead>
    <tr>
      <th>Voter</th>
      <th class="mobile hidden">Time</th>
      <th class="mobile right aligned">Power</th>
    </tr>
  </thead>
  <tbody>
    {% for voter in votes %}
    <tr>
      <td>
        <a href="/@{{ voter.voter }}">
          {{ voter.voter }}
        </a>
      </td>
      <td class="mobile hidden">
        <?php echo $voter->_ts->toDateTime()->format('Y/m/d H:i:s') ?>
      </td>
      <td class="mobile right aligned">
        {{ voter.weight / 100 }}%
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
