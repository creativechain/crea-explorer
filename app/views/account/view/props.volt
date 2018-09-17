<h3 class="ui header">
  Witness Props History
  <div class="sub header">
    The history of the account's witness properties.
  </div>
</h3>
<table class="ui attached table">
  <thead>
    <tr>
      <th>Date</th>
      <th>Creation Fee</th>
      <th>Block Size</th>
    </tr>
  </thead>
  <tbody>
    {% for props in history %}
    <tr>
      <td>
        {{ props.created.toDateTime().format('Y-m-d') }}
      <td>
        {{ props.props['account_creation_fee'] }}
      </td>
      <td>
        {{ props.props['maximum_block_size'] }}
      </td>
    </tr>
    {% endfor %}
  </tbody>
</table>
