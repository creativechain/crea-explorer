<h3 class="ui dividing header">Content</h3>
<div class="ui relaxed list" style="text-align: center; color: #000;">
  <div class="item">
		{% include '_elements/definition_table' with ['data': {'title':comment.title,'body':comment.body,'json_metadata':comment.json_metadata}] %}
  </div>
</div>
