<div class="ui card">
  <div class="content">
    {% if live[0] is defined and live[0]['metadata'] is defined and live[0]['metadata']['avatar'] is defined %}
    <img class="right floated avatar image" src="{{ live[0]['metadata']['avatar']['url'] | e }}">
    {% endif %}
    <div class="header">
      <span class="ui circular blue tiny label" style="margin-left: 0; vertical-align: top;">
        <?php echo $this->reputation::number($account->reputation) ?>
      </span>
      <a href="/@{{ account.name }}">
        {{ account.name }}
      </a>
    </div>
    <div class="meta">
      joined <?php echo $this->timeAgo::mongo($account->created); ?>
    </div>
    {% if live[0] is defined and live[0] is defined and live[0]['metadata'] is defined and live[0]['metadata']['about'] is defined %}
    <div class="description">
      {{ live[0]['metadata']['about'] | e }}
    </div>
    {% endif %}
    {% if live[0] is defined and live[0] is defined and live[0]['metadata'] is defined and live[0]['metadata']['web'] is defined %}
      <div class="description">
        <br><i class="linkify icon"></i>
        <a rel="nofollow noopener" href="{{ live[0]['metadata']['web'] | e }}">
          {{ live[0]['metadata']['web'] | e }}
        </a>
      </div>
    {% endif %}

  </div>
  <div class="extra content">
    <span class="right floated">
      {% if live[0] is defined and live[0] is defined and live[0]['metadata'] is defined and live[0]['metadata']['contact'] is defined %}
        <i class="marker icon"></i>
        {{ live[0]['metadata']['contact'] | e }}
      {% endif %}
    </span>
    <span>
      <i class="users icon"></i>
      {{ account.follower_count }} Followers
    </span>
    <span>
      <i class="users icon"></i>
      {{ account.following_count }} Following
    </span>
  </div>
</div>
