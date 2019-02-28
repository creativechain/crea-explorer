{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="twelve wide column">
        <div class="ui huge header" style="color: #f6f6f6;">
          {{ comment.title }}
          <div class="sub header" style="color: #f6f6f6;">
            by
            <a href="/@{{ comment.author }}">
              {{ comment.author }}
            </a>
          </div>
        </div>
        <div class="ui top attached tabular menu">
          {{ link_to(["for": "comment-view", "category": comment.category, "author": comment.author, "permlink": comment.permlink], "Content", "class": "item item-alt" ~ (router.getActionName() == "view" ? " active" : "")) }}
          {{ link_to(["for": "comment-view-section", "category": comment.category, "author": comment.author, "permlink": comment.permlink, "action": "tags"], "Tags", "class": "item item-alt" ~ (router.getActionName() == "tags" ? " active" : "")) }}
          {{ link_to(["for": "comment-view-section", "category": comment.category, "author": comment.author, "permlink": comment.permlink, "action": "replies"], "Replies", "class": "item item-alt" ~ (router.getActionName() == "replies" ? " active" : "")) }}
          {{ link_to(["for": "comment-view-section", "category": comment.category, "author": comment.author, "permlink": comment.permlink, "action": "reblogs"], "Reblogs", "class": "item item-alt" ~ (router.getActionName() == "reblogs" ? " active" : "")) }}
          {{ link_to(["for": "comment-view-section", "category": comment.category, "author": comment.author, "permlink": comment.permlink, "action": "votes"], "Votes", "class": "item item-alt" ~ (router.getActionName() == "votes" ? " active" : "")) }}
          {{ link_to(["for": "comment-view-section", "category": comment.category, "author": comment.author, "permlink": comment.permlink, "action": "edits"], "Edit History (" ~ (edits | length) ~ ")", "class": "item item-alt" ~ (router.getActionName() == "edits" ? " active" : "")) }}
          {{ link_to(["for": "comment-view-section", "category": comment.category, "author": comment.author, "permlink": comment.permlink, "action": "data"], "Data", "class": "item item-alt" ~ (router.getActionName() == "data" ? " active" : "")) }}
        </div>
        <div class="ui bottom attached padded segment">
          <div class="ui active tab">
            {% include "comment/view/" ~ router.getActionName() %}
          </div>
        </div>

        {#<div class="ui bottom attached padded segment">
          <div class="ui active tab" data-tab="post">
            {% include "comment/view/content.volt" %}
          </div>
          <div class="ui tab" data-tab="tags">
            {% include "comment/view/tags.volt" %}
          </div>
          <div class="ui tab" data-tab="replies">
            {% include "comment/view/replies.volt" %}
          </div>
          <div class="ui tab" data-tab="reblogs">
            {% include "comment/view/reblogs.volt" %}
          </div>
          <div class="ui tab" data-tab="votes">
            {% include "comment/view/votes.volt" %}
          </div>
          <div class="ui tab" data-tab="data">
            {% include "comment/view/data.volt" %}
          </div>
        /div>#}
      </div>
      <div class="four wide column">
        {% include '_elements/cards/account' with ['account': author] %}
        <div class="ui list">
          <div class="item">
            <a href="https://creary.net/@{{comment.author}}/{{comment.permlink}}" class="ui fluid primary icon small button" target="_blank">
              <i class="external icon"></i>
              View Post on Creary
            </a>
          </div>
        </div>
        {% include '_elements/sidebar/earnings.volt' %}
        {% include '_elements/sidebar/readmore.volt' %}
        {% include '_elements/sidebar/commands.volt' %}
      </div>
    </div>
  </div>
</div>
{% endblock %}

{% block scripts %}
<script>
  $('.tabular.menu .item')
    .tab({

    })
  ;
  $("#table-votes").tablesort();
</script>
{% endblock %}
