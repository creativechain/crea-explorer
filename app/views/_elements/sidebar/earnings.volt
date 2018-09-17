<table class="ui small definition table">
  <tbody>
    <tr>
      <td>Earnings</td>
      <td>{{ comment.total_payout_value }} VIT</td>
    </tr>
    <tr>
      <td>Pending</td>
      <td><?php echo $this->largeNumber::format($comment->total_pending_payout_value); ?> VIT</td>
    </tr>
  </tbody>
</table>
