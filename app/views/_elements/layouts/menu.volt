<div class="ui fixed inverted blue main menu">
  <div class="ui container">
    <a class="launch icon item">
      <i class="content icon"></i>
    </a>

    <div class="right menu">
      <div class="ui category search item">
        <div class="ui icon input">
          <input class="prompt" type="text" placeholder="Search accounts...">
          <i class="search icon"></i>
        </div>
        <div class="results"></div>
      </div>
    </div>
  </div>
</div>
<!-- Following Menu -->
<div class="ui blue inverted top fixed mobile hidden menu">
  <div class="ui container">
    <a href="/" class="brand">
      <img class="header item" src="/img/crea-scan-logo.svg" style="height: 40px;padding: 5px 10px 5px 0;" />
    </a>
    <a href="/accounts" class="{{ (router.getControllerName() == 'account' or router.getControllerName() == 'accounts') ? 'active' : '' }} item">accounts</a>
    <a class="{{ (router.getControllerName() == 'comments') ? 'active' : '' }} item" href="/posts">posts</a>
    <a href="/witnesses" class="{{ (router.getControllerName() == 'witness') ? 'active' : '' }} item">witnesses</a>
    <a href="/blocks" class="{{ (router.getControllerName() == 'blocks') ? 'active' : '' }} item">blocks</a>
    <div class="right menu">
      <div class="item">
        <a href="https://test.creary.net/welcome" target="_blank" rel="nofollow">
          <small>Create Account</small>
        </a>
      </div>
      <div class="ui category search item">
        <div class="ui icon input">
          <input class="prompt" type="text" placeholder="Search accounts...">
          <i class="search icon"></i>
        </div>
        <div class="results"></div>
      </div>
    </div>
  </div>
</div>

<!-- Sidebar Menu -->
<div class="ui vertical inverted sidebar menu">
  <a href="/accounts" class="{{ (router.getControllerName() == 'account' or router.getControllerName() == 'accounts') ? 'active' : '' }} item">accounts</a>
  <a href="/posts" class="{{ (router.getControllerName() == 'comments') ? 'active' : '' }} item">posts</a>
  <a href="/witnesses" class="{{ (router.getControllerName() == 'witness') ? 'active' : '' }} item">witnesses</a>
  <a href="/blocks" class="{{ (router.getControllerName() == 'blocks') ? 'active' : '' }} item">blocks</a>
</div>
