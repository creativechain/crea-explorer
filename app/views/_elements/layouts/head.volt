<head>
  <meta property="og:url" content="https://creascan.net" />
  <meta property="og:type" content="website" />
  <meta property="og:title" content="CREASCAN - Explore CREA network" />
  <meta property="og:image" content="/img/creascan-og.jpg" />
  <meta property="og:description" content="Creascan allows you to explore and search all CREA Blockchain activity, transactions, operations, addresses, tokens, and other activities related to network users." />
  <meta property="twitter:card" content="summary_large_image"/>
  <meta property="twitter:site" content="@crearynet"/>
  <meta property="twitter:title" content="CREASCAN - Explore CREA network" />
  <meta property="twitter:description" content="Creascan allows you to explore and search all CREA Blockchain activity, transactions, operations, addresses, tokens, and other activities related to network users."/>
  <meta property="twitter:image" content="/img/creascan-og.jpg" />
  <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no,minimal-ui' />

  <title>CREA SCAN - CREA Blockchain Explorer</title>
  {% if post is defined %}
  <link rel="canonical" href="https://creary.net/@{{ post.author }}/{{ post.permlink }}"/>
  {% endif %}
  {% if posts is defined and posts[0] is defined %}
  <link rel="canonical" href="https://creary.net/@{{ posts[0].author }}/{{ posts[0].permlink }}"/>
  {% endif %}
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.0/semantic.min.css">
  <style>
    body {
      color: #fff;
    }
    .ui.tabular.menu .item:hover {
      color: #0073ff;
    }
    .offwhite {
      color: #f3f3f3 !important;
    }
    .brand {
      padding-top: .3em !important;
    }
    .ui.vertical.sidebar.menu {
      padding-top: 3em !important;
    }
    .seethrough {
      background: rgba(255,255,255,.95) !important;
    }
    .pusher {
      min-height: 400px;
    }
    .ui.tabular.menu .item {
      color: #000;
    }
    .ui.tabular.menu .item-alt {
      color: #f3f3f3;
    }
    .ui.inverted.blue.menu {
      background: #0073FF;
    }
    .ui.indicating.progress.success .label {
      color: #15DF00 !important;
    }
    body.pushable>.pusher {
      background-image: url('/img/background.jpg') !important;
      background-position: center;
      background-repeat: no-repeat;
      background-attachment: fixed;
      -webkit-background-size: cover;
      -moz-background-size: cover;
      -o-background-size: cover;
      background-size: cover;
    }
    .ui.vertical.stripe {
      padding: 3em 0em;
    }
    .ui.vertical.stripe h3 {
      font-size: 2em;
    }
    .ui.vertical.stripe .button + h3,
    .ui.vertical.stripe p + h3 {
      margin-top: 3em;
    }
    .ui.vertical.stripe .floated.image {
      clear: both;
    }
    .ui.vertical.stripe p {
      font-size: 1.33em;
    }
    .ui.vertical.stripe .horizontal.divider {
      margin: 3em 0em;
    }
    .quote.stripe.segment {
      padding: 0em;
    }
    .quote.stripe.segment .grid .column {
      padding-top: 5em;
      padding-bottom: 5em;
    }
    .footer.segment {
      padding: 1em 0em;
      position: absolute;
      width: 100%;
      bottom: 0px;
    }
    .footer.segment a {
      color: #fff;
      text-decoration: underline;
    }
    .comment img,
    .markdown img {
      max-width: 100%;
      height:auto;
      display: block;
    }
    .markdown {
      font-size: 1.25em;
    }
    .markdown div.pull-left {
      float: left;
      padding-right: 1rem;
      max-width: 50%;
    }
    .markdown div.pull-right {
      float: right;
      padding-left: 1rem;
      max-width: 50%;
    }
    .markdown blockquote, .markdown blockquote p {
      line-height: 1.6;
      color: #8a8a8a;
    }
    .markdown blockquote {
      margin: 0 0 1rem;
      padding: .53571rem 1.19048rem 0 1.13095rem;
      border-left: 1px solid #cacaca;
    }
    .markdown code {
      white-space: pre;
      font-family: Consolas,Liberation Mono,Courier,monospace;
      display: block;
      padding: 10px;
      background: #f4f4f4;
      border-radius: 3px;
    }
    .ui.comments {
      max-width: auto;
    }
    .ui.comments .comment .comments {
      padding-left: 3em;
    }
    .definition.table td.wide {
      overflow-x: auto;
    }
    .ui.body.container {
      margin: 3em 0;
    }
    .ui.comments .comment .avatar img, .ui.comments .comment img.avatar {
      border-radius: 20px;
    }
    @media only screen and (min-width: 768px) {
      body .ui.table:not(.unstackable) tr>td.mobile.visible,
      body .ui.table:not(.unstackable) tr>th.mobile.visible,
      .mobile.visible {
        display: none
      }
    }
    @media only screen and (max-width: 767px) {
      .ui.tabular.menu {
        overflow-y: scroll;
      }
      body .ui.table:not(.unstackable) tr>td.mobile.hidden,
      body .ui.table:not(.unstackable) tr>th.mobile.hidden,
      .mobile.hidden {
        display: none !important;
      }
    }
  </style>
  <link rel="stylesheet" href="/bower/plottable/plottable.css">
  <link rel="stylesheet" href="/css/style.css">
  <link rel="apple-touch-icon" sizes="180x180" href="/img/apple-touch-icon.png">
  <link rel="icon" type="image/vnd.microsoft.icon" sizes="16x16 24x24 36x36"  href="/img/favicon.ico">
  <link rel="manifest" href="/img/site.webmanifest">
  <link rel="mask-icon" href="/img/safari-pinned-tab.svg" color="#5bbad5">
  <meta name="msapplication-TileColor" content="#da532c">
  <meta name="theme-color" content="#ffffff">
</head>
