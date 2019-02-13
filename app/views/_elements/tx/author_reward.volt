<span class="ui purple label">
  +<?php echo $this->largeNumber::format($item[1]['op'][1]['crea_payout']); ?> CREA
</span>
<span class="ui blue label">
  +<?php echo $this->convert::vest2cgy($item[1]['op'][1]['vesting_payout']); ?>
</span>
for
<a href="/tag/@{{ item[1]['op'][1]['author'] }}/{{ item[1]['op'][1]['permlink'] }}">
  <?= substr($item[1]['op'][1]['permlink'], 0, 75) ?>
</a>
