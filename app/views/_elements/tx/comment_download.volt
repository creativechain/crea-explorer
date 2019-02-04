<span class="ui left labeled button" tabindex="0">
  <a href="/@{{ item[1]['op'][1]['downloader'] }}" class="ui basic right pointing label">
    {{ item[1]['op'][1]['downloader'] }}
  </a>
  <a href="/@{{ item[1]['op'][1]['comment_author'] }}" class="ui button">
    {{ item[1]['op'][1]['comment_author'] }}
  </a>
</span>
<span class="ui green label">
  <a href="/tag/@{{ item[1]['op'][1]['comment_author'] }}/{{ item[1]['op'][1]['comment_permlink'] }}">
    {{ item[1]['op'][1]['comment_permlink'] }}
  </a>
</span>