


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>history.js/scripts/uncompressed/history.adapter.native.js at master · balupton/history.js · GitHub</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />

    
    

    <meta content="authenticity_token" name="csrf-param" />
<meta content="7mPT45RHyNEMU9m2CkRx0nvsHY5wGo9jMPUzRA+vUZ0=" name="csrf-token" />

    <link href="https://a248.e.akamai.net/assets.github.com/stylesheets/bundles/github-3d39615bc3aebca5809be0e8a89c65b44d36ba5f.css" media="screen" rel="stylesheet" type="text/css" />
    <link href="https://a248.e.akamai.net/assets.github.com/stylesheets/bundles/github2-8f1cebd25e891ff7aef47980a4baa9cf03669bdf.css" media="screen" rel="stylesheet" type="text/css" />
    

    <script src="https://a248.e.akamai.net/assets.github.com/javascripts/bundles/jquery-2d0d4e0119675485f7a3d0dd7f49420b63c552ae.js" type="text/javascript"></script>
    
    <script src="https://a248.e.akamai.net/assets.github.com/javascripts/bundles/github-f620fdd467f8ad62dc7594023fd68ac3b38c9ca1.js" type="text/javascript"></script>
    

      <link rel='permalink' href='/balupton/history.js/blob/de8554b91e5a92840cefb63a6bba9a051fb39b66/scripts/uncompressed/history.adapter.native.js'>
    <meta property="og:title" content="history.js"/>
    <meta property="og:type" content="githubog:gitrepository"/>
    <meta property="og:url" content="https://github.com/balupton/history.js"/>
    <meta property="og:image" content="https://a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-140.png?1329275856"/>
    <meta property="og:site_name" content="GitHub"/>
    <meta property="og:description" content="history.js - History.js gracefully supports the HTML5 History/State APIs (pushState, replaceState, onPopState) in all browsers. Including continued support for data, titles, replaceState. Supports jQuery, MooTools and Prototype.  For HTML5 browsers this means that you can modify the URL directly, without needing to use hashes anymore. For HTML4 browsers it will revert back to using the old onhashchange functionality."/>

    <meta name="description" content="history.js - History.js gracefully supports the HTML5 History/State APIs (pushState, replaceState, onPopState) in all browsers. Including continued support for data, titles, replaceState. Supports jQuery, MooTools and Prototype.  For HTML5 browsers this means that you can modify the URL directly, without needing to use hashes anymore. For HTML4 browsers it will revert back to using the old onhashchange functionality." />
  <link href="https://github.com/balupton/history.js/commits/master.atom" rel="alternate" title="Recent Commits to history.js:master" type="application/atom+xml" />

  </head>


  <body class="logged_out page-blob  vis-public env-production " data-blob-contribs-enabled="yes">
    <div id="wrapper">

    
    
    

      <div id="header" class="true clearfix">
        <div class="container clearfix">
          <a class="site-logo" href="https://github.com">
            <!--[if IE]>
            <img alt="GitHub" class="github-logo" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov7.png?1323882717" />
            <img alt="GitHub" class="github-logo-hover" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov7-hover.png?1324325358" />
            <![endif]-->
            <img alt="GitHub" class="github-logo-4x" height="30" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov7@4x.png?1323882717" />
            <img alt="GitHub" class="github-logo-4x-hover" height="30" src="https://a248.e.akamai.net/assets.github.com/images/modules/header/logov7@4x-hover.png?1324325358" />
          </a>

                  <!--
      make sure to use fully qualified URLs here since this nav
      is used on error pages on other domains
    -->
    <ul class="top-nav logged_out">
        <li class="pricing"><a href="https://github.com/plans">Signup and Pricing</a></li>
        <li class="explore"><a href="https://github.com/explore">Explore GitHub</a></li>
      <li class="features"><a href="https://github.com/features">Features</a></li>
        <li class="blog"><a href="https://github.com/blog">Blog</a></li>
      <li class="login"><a href="https://github.com/login?return_to=%2Fbalupton%2Fhistory.js%2Fblob%2Fmaster%2Fscripts%2Funcompressed%2Fhistory.adapter.native.js">Login</a></li>
    </ul>



          
        </div>
      </div>

      

            <div class="site hfeed" itemscope itemtype="http://schema.org/WebPage">
      <div class="container hentry">
        <div class="pagehead repohead instapaper_ignore readability-menu">
        <div class="title-actions-bar">
          



              <ul class="pagehead-actions">


          <li><a href="/login?return_to=%2Fbalupton%2Fhistory.js" class="minibutton btn-watch watch-button entice tooltipped leftwards" rel="nofollow" title="You must be logged in to use this feature"><span><span class="icon"></span>Watch</span></a></li>
          <li><a href="/login?return_to=%2Fbalupton%2Fhistory.js" class="minibutton btn-fork fork-button entice tooltipped leftwards" rel="nofollow" title="You must be logged in to use this feature"><span><span class="icon"></span>Fork</span></a></li>


      <li class="repostats">
        <ul class="repo-stats">
          <li class="watchers ">
            <a href="/balupton/history.js/watchers" title="Watchers" class="tooltipped downwards">
              2,492
            </a>
          </li>
          <li class="forks">
            <a href="/balupton/history.js/network" title="Forks" class="tooltipped downwards">
              137
            </a>
          </li>
        </ul>
      </li>
    </ul>

          <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title">
            <span class="mini-icon public-repo"></span>
            <span class="author vcard">
<a href="/balupton" class="url fn" itemprop="url" rel="author">              <span itemprop="title">balupton</span>
              </a></span> /
            <strong><a href="/balupton/history.js" class="js-current-repository">history.js</a></strong>
          </h1>
        </div>

          

  <ul class="tabs">
    <li><a href="/balupton/history.js" class="selected" highlight="repo_sourcerepo_downloadsrepo_commitsrepo_tagsrepo_branches">Code</a></li>
    <li><a href="/balupton/history.js/network" highlight="repo_network">Network</a>
    <li><a href="/balupton/history.js/pulls" highlight="repo_pulls">Pull Requests <span class='counter'>15</span></a></li>

      <li><a href="/balupton/history.js/issues" highlight="repo_issues">Issues <span class='counter'>95</span></a></li>

      <li><a href="/balupton/history.js/wiki" highlight="repo_wiki">Wiki <span class='counter'>9</span></a></li>

    <li><a href="/balupton/history.js/graphs" highlight="repo_graphsrepo_contributors">Stats &amp; Graphs</a></li>

  </ul>
 
<div class="frame frame-center tree-finder" style="display:none"
      data-tree-list-url="/balupton/history.js/tree-list/de8554b91e5a92840cefb63a6bba9a051fb39b66"
      data-blob-url-prefix="/balupton/history.js/blob/de8554b91e5a92840cefb63a6bba9a051fb39b66"
    >

  <div class="breadcrumb">
    <span class="bold"><a href="/balupton/history.js">history.js</a></span> /
    <input class="tree-finder-input js-navigation-enable" type="text" name="query" autocomplete="off" spellcheck="false">
  </div>

    <div class="octotip">
      <p>
        <a href="/balupton/history.js/dismiss-tree-finder-help" class="dismiss js-dismiss-tree-list-help" title="Hide this notice forever" rel="nofollow">Dismiss</a>
        <span class="bold">Octotip:</span> You've activated the <em>file finder</em>
        by pressing <span class="kbd">t</span> Start typing to filter the
        file list. Use <span class="kbd badmono">↑</span> and
        <span class="kbd badmono">↓</span> to navigate,
        <span class="kbd">enter</span> to view files.
      </p>
    </div>

  <table class="tree-browser" cellpadding="0" cellspacing="0">
    <tr class="js-header"><th>&nbsp;</th><th>name</th></tr>
    <tr class="js-no-results no-results" style="display: none">
      <th colspan="2">No matching files</th>
    </tr>
    <tbody class="js-results-list js-navigation-container">
    </tbody>
  </table>
</div>

<div id="jump-to-line" style="display:none">
  <h2>Jump to Line</h2>
  <form accept-charset="UTF-8">
    <input name="utf8" type="hidden" value="&#x2713;" />
    <input class="textfield" type="text">
    <div class="full-button">
      <button type="submit" class="classy">
        <span>Go</span>
      </button>
    </div>
  </form>
</div>


<div class="subnav-bar">

  <ul class="actions subnav">
    <li><a href="/balupton/history.js/tags" class="blank" highlight="repo_tags">Tags <span class="counter">0</span></a></li>
    <li><a href="/balupton/history.js/downloads" class="blank downloads-blank" highlight="repo_downloads">Downloads <span class="counter">0</span></a></li>
    
  </ul>

  <ul class="scope">
    <li class="switcher">

      <div class="context-menu-container js-menu-container">
        <a href="#"
           class="minibutton bigger switcher js-menu-target js-commitish-button btn-branch repo-tree"
           data-master-branch="master"
           data-ref="master">
          <span><span class="icon"></span><i>branch:</i> master</span>
        </a>

        <div class="context-pane commitish-context js-menu-content">
          <a href="javascript:;" class="close js-menu-close"></a>
          <div class="context-title">Switch Branches/Tags</div>
          <div class="context-body pane-selector commitish-selector js-filterable-commitishes">
            <div class="filterbar">
              <div class="placeholder-field js-placeholder-field">
                <label class="placeholder" for="context-commitish-filter-field" data-placeholder-mode="sticky">Filter branches/tags</label>
                <input type="text" id="context-commitish-filter-field" class="commitish-filter" />
              </div>

              <ul class="tabs">
                <li><a href="#" data-filter="branches" class="selected">Branches</a></li>
                <li><a href="#" data-filter="tags">Tags</a></li>
              </ul>
            </div>

              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/dev/scripts/uncompressed/history.adapter.native.js" data-name="dev" rel="nofollow">dev</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/gh-pages/scripts/uncompressed/history.adapter.native.js" data-name="gh-pages" rel="nofollow">gh-pages</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/master/scripts/uncompressed/history.adapter.native.js" data-name="master" rel="nofollow">master</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.0/scripts/uncompressed/history.adapter.native.js" data-name="v1.0" rel="nofollow">v1.0</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.1/scripts/uncompressed/history.adapter.native.js" data-name="v1.1" rel="nofollow">v1.1</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.2/scripts/uncompressed/history.adapter.native.js" data-name="v1.2" rel="nofollow">v1.2</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.3/scripts/uncompressed/history.adapter.native.js" data-name="v1.3" rel="nofollow">v1.3</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.4/scripts/uncompressed/history.adapter.native.js" data-name="v1.4" rel="nofollow">v1.4</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.5/scripts/uncompressed/history.adapter.native.js" data-name="v1.5" rel="nofollow">v1.5</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.6/scripts/uncompressed/history.adapter.native.js" data-name="v1.6" rel="nofollow">v1.6</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.7/scripts/uncompressed/history.adapter.native.js" data-name="v1.7" rel="nofollow">v1.7</a>
                </h4>
              </div>
              <div class="commitish-item branch-commitish selector-item">
                <h4>
                    <a href="/balupton/history.js/blob/v1.7-dev/scripts/uncompressed/history.adapter.native.js" data-name="v1.7-dev" rel="nofollow">v1.7-dev</a>
                </h4>
              </div>


            <div class="no-results" style="display:none">Nothing to show</div>
          </div>
        </div><!-- /.commitish-context-context -->
      </div>

    </li>
  </ul>

  <ul class="subnav with-scope">

    <li><a href="/balupton/history.js" class="selected" highlight="repo_source">Files</a></li>
    <li><a href="/balupton/history.js/commits/master" highlight="repo_commits">Commits</a></li>
    <li><a href="/balupton/history.js/branches" class="" highlight="repo_branches" rel="nofollow">Branches <span class="counter">12</span></a></li>
  </ul>

</div>

  
  
  


          

        </div><!-- /.repohead -->

        





<!-- block_view_fragment_key: views7/v8/blob:v21:f17d2b0f5ecf761121305db27c771fd2 -->
  <div id="slider">

    <div class="breadcrumb" data-path="scripts/uncompressed/history.adapter.native.js/">
      <b itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/balupton/history.js/tree/d0e4565048ae35ac08aebe1ef6be5c067717df1e" class="js-rewrite-sha" itemprop="url"><span itemprop="title">history.js</span></a></b> / <span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/balupton/history.js/tree/d0e4565048ae35ac08aebe1ef6be5c067717df1e/scripts" class="js-rewrite-sha" itemscope="url"><span itemprop="title">scripts</span></a></span> / <span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/balupton/history.js/tree/d0e4565048ae35ac08aebe1ef6be5c067717df1e/scripts/uncompressed" class="js-rewrite-sha" itemscope="url"><span itemprop="title">uncompressed</span></a></span> / <strong class="final-path">history.adapter.native.js</strong> <span class="js-clippy mini-icon clippy " data-clipboard-text="scripts/uncompressed/history.adapter.native.js" data-copied-hint="copied!" data-copy-hint="copy to clipboard"></span>
    </div>


      <div class="commit file-history-tease" data-path="scripts/uncompressed/history.adapter.native.js/">
        <img class="main-avatar" height="24" src="https://secure.gravatar.com/avatar/9400cb5aeb155ccec614652542fd274d?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png" width="24" />
        <span class="author"><a href="/balupton">balupton</a></span>
        <time class="js-relative-date" datetime="2011-10-03T20:38:42-07:00" title="2011-10-03 20:38:42">October 03, 2011</time>
        <div class="commit-title">
            <a href="/balupton/history.js/commit/d0e4565048ae35ac08aebe1ef6be5c067717df1e" class="message">v1.7.1. Added a new native adapter. Provided bundled files. Added ses…</a>
        </div>

        <div class="participation">
          <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>1</strong> contributor</a></p>
          
        </div>
        <div id="blob_contributors_box" style="display:none">
          <h2>Users on GitHub who have contributed to this file</h2>
          <ul class="facebox-user-list">
            <li>
              <img height="24" src="https://secure.gravatar.com/avatar/9400cb5aeb155ccec614652542fd274d?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png" width="24" />
              <a href="/balupton">balupton</a>
            </li>
          </ul>
        </div>
      </div>

    <div class="frames">
      <div class="frame frame-center" data-path="scripts/uncompressed/history.adapter.native.js/" data-permalink-url="/balupton/history.js/blob/d0e4565048ae35ac08aebe1ef6be5c067717df1e/scripts/uncompressed/history.adapter.native.js" data-title="history.js/scripts/uncompressed/history.adapter.native.js at d0e4565048ae35ac08aebe1ef6be5c067717df1e · balupton/history.js · GitHub" data-type="blob">

        <div id="files" class="bubble">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><b class="mini-icon text-file"></b></span>
                <span class="mode" title="File Mode">100644</span>
                  <span>122 lines (105 sloc)</span>
                <span>3.117 kb</span>
              </div>
              <ul class="button-group actions">
                  <li>
                    <a class="grouped-button file-edit-link minibutton bigger lighter js-rewrite-sha" href="/balupton/history.js/edit/d0e4565048ae35ac08aebe1ef6be5c067717df1e/scripts/uncompressed/history.adapter.native.js" data-method="post" rel="nofollow"><span>Edit this file</span></a>
                  </li>

                <li>
                  <a href="/balupton/history.js/raw/d0e4565048ae35ac08aebe1ef6be5c067717df1e/scripts/uncompressed/history.adapter.native.js" class="minibutton btn-raw grouped-button bigger lighter" id="raw-url"><span><span class="icon"></span>Raw</span></a>
                </li>
                  <li>
                    <a href="/balupton/history.js/blame/d0e4565048ae35ac08aebe1ef6be5c067717df1e/scripts/uncompressed/history.adapter.native.js" class="minibutton btn-blame grouped-button bigger lighter"><span><span class="icon"></span>Blame</span></a>
                  </li>
                <li>
                  <a href="/balupton/history.js/commits/d0e4565048ae35ac08aebe1ef6be5c067717df1e/scripts/uncompressed/history.adapter.native.js" class="minibutton btn-history grouped-button bigger lighter" rel="nofollow"><span><span class="icon"></span>History</span></a>
                </li>
              </ul>
            </div>
              <div class="data type-javascript">
      <table cellpadding="0" cellspacing="0" class="lines">
        <tr>
          <td>
            <pre class="line_numbers"><span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
<span id="L105" rel="#L105">105</span>
<span id="L106" rel="#L106">106</span>
<span id="L107" rel="#L107">107</span>
<span id="L108" rel="#L108">108</span>
<span id="L109" rel="#L109">109</span>
<span id="L110" rel="#L110">110</span>
<span id="L111" rel="#L111">111</span>
<span id="L112" rel="#L112">112</span>
<span id="L113" rel="#L113">113</span>
<span id="L114" rel="#L114">114</span>
<span id="L115" rel="#L115">115</span>
<span id="L116" rel="#L116">116</span>
<span id="L117" rel="#L117">117</span>
<span id="L118" rel="#L118">118</span>
<span id="L119" rel="#L119">119</span>
<span id="L120" rel="#L120">120</span>
<span id="L121" rel="#L121">121</span>
</pre>
          </td>
          <td width="100%">
                <div class="highlight"><pre><div class='line' id='LC1'><span class="cm">/**</span></div><div class='line' id='LC2'><span class="cm"> * History.js Native Adapter</span></div><div class='line' id='LC3'><span class="cm"> * @author Benjamin Arthur Lupton &lt;contact@balupton.com&gt;</span></div><div class='line' id='LC4'><span class="cm"> * @copyright 2010-2011 Benjamin Arthur Lupton &lt;contact@balupton.com&gt;</span></div><div class='line' id='LC5'><span class="cm"> * @license New BSD License &lt;http://creativecommons.org/licenses/BSD/&gt;</span></div><div class='line' id='LC6'><span class="cm"> */</span></div><div class='line' id='LC7'><br/></div><div class='line' id='LC8'><span class="c1">// Closure</span></div><div class='line' id='LC9'><span class="p">(</span><span class="kd">function</span><span class="p">(</span><span class="nb">window</span><span class="p">,</span><span class="kc">undefined</span><span class="p">){</span></div><div class='line' id='LC10'>	<span class="s2">&quot;use strict&quot;</span><span class="p">;</span></div><div class='line' id='LC11'><br/></div><div class='line' id='LC12'>	<span class="c1">// Localise Globals</span></div><div class='line' id='LC13'>	<span class="kd">var</span> <span class="nx">History</span> <span class="o">=</span> <span class="nb">window</span><span class="p">.</span><span class="nx">History</span> <span class="o">=</span> <span class="nb">window</span><span class="p">.</span><span class="nx">History</span><span class="o">||</span><span class="p">{};</span></div><div class='line' id='LC14'><br/></div><div class='line' id='LC15'>	<span class="c1">// Check Existence</span></div><div class='line' id='LC16'>	<span class="k">if</span> <span class="p">(</span> <span class="k">typeof</span> <span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span> <span class="o">!==</span> <span class="s1">&#39;undefined&#39;</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC17'>		<span class="k">throw</span> <span class="k">new</span> <span class="nb">Error</span><span class="p">(</span><span class="s1">&#39;History.js Adapter has already been loaded...&#39;</span><span class="p">);</span></div><div class='line' id='LC18'>	<span class="p">}</span></div><div class='line' id='LC19'><br/></div><div class='line' id='LC20'>	<span class="c1">// Add the Adapter</span></div><div class='line' id='LC21'>	<span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span> <span class="o">=</span> <span class="p">{</span></div><div class='line' id='LC22'>		<span class="cm">/**</span></div><div class='line' id='LC23'><span class="cm">		 * History.Adapter.handlers[uid][eventName] = Array</span></div><div class='line' id='LC24'><span class="cm">		 */</span></div><div class='line' id='LC25'>		<span class="nx">handlers</span><span class="o">:</span> <span class="p">{},</span></div><div class='line' id='LC26'><br/></div><div class='line' id='LC27'>		<span class="cm">/**</span></div><div class='line' id='LC28'><span class="cm">		 * History.Adapter._uid</span></div><div class='line' id='LC29'><span class="cm">		 * The current element unique identifier</span></div><div class='line' id='LC30'><span class="cm">		 */</span></div><div class='line' id='LC31'>		<span class="nx">_uid</span><span class="o">:</span> <span class="mi">1</span><span class="p">,</span></div><div class='line' id='LC32'><br/></div><div class='line' id='LC33'>		<span class="cm">/**</span></div><div class='line' id='LC34'><span class="cm">		 * History.Adapter.uid(element)</span></div><div class='line' id='LC35'><span class="cm">		 * @param {Element} element</span></div><div class='line' id='LC36'><span class="cm">		 * @return {String} uid</span></div><div class='line' id='LC37'><span class="cm">		 */</span></div><div class='line' id='LC38'>		 <span class="nx">uid</span><span class="o">:</span> <span class="kd">function</span><span class="p">(</span><span class="nx">element</span><span class="p">){</span></div><div class='line' id='LC39'>			<span class="k">return</span> <span class="nx">element</span><span class="p">.</span><span class="nx">_uid</span> <span class="o">||</span> <span class="p">(</span><span class="nx">element</span><span class="p">.</span><span class="nx">_uid</span> <span class="o">=</span> <span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">_uid</span><span class="o">++</span><span class="p">);</span></div><div class='line' id='LC40'>		 <span class="p">},</span></div><div class='line' id='LC41'><br/></div><div class='line' id='LC42'>		<span class="cm">/**</span></div><div class='line' id='LC43'><span class="cm">		 * History.Adapter.bind(el,event,callback)</span></div><div class='line' id='LC44'><span class="cm">		 * @param {Element} element</span></div><div class='line' id='LC45'><span class="cm">		 * @param {String} eventName - custom and standard events</span></div><div class='line' id='LC46'><span class="cm">		 * @param {Function} callback</span></div><div class='line' id='LC47'><span class="cm">		 * @return</span></div><div class='line' id='LC48'><span class="cm">		 */</span></div><div class='line' id='LC49'>		<span class="nx">bind</span><span class="o">:</span> <span class="kd">function</span><span class="p">(</span><span class="nx">element</span><span class="p">,</span><span class="nx">eventName</span><span class="p">,</span><span class="nx">callback</span><span class="p">){</span></div><div class='line' id='LC50'>			<span class="c1">// Prepare</span></div><div class='line' id='LC51'>			<span class="kd">var</span> <span class="nx">uid</span> <span class="o">=</span> <span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">uid</span><span class="p">(</span><span class="nx">element</span><span class="p">);</span></div><div class='line' id='LC52'><br/></div><div class='line' id='LC53'>			<span class="c1">// Apply Listener</span></div><div class='line' id='LC54'>			<span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">]</span> <span class="o">=</span> <span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">]</span> <span class="o">||</span> <span class="p">{};</span></div><div class='line' id='LC55'>			<span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">][</span><span class="nx">eventName</span><span class="p">]</span> <span class="o">=</span> <span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">][</span><span class="nx">eventName</span><span class="p">]</span> <span class="o">||</span> <span class="p">[];</span></div><div class='line' id='LC56'>			<span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">][</span><span class="nx">eventName</span><span class="p">].</span><span class="nx">push</span><span class="p">(</span><span class="nx">callback</span><span class="p">);</span></div><div class='line' id='LC57'><br/></div><div class='line' id='LC58'>			<span class="c1">// Bind Global Listener</span></div><div class='line' id='LC59'>			<span class="nx">element</span><span class="p">[</span><span class="s1">&#39;on&#39;</span><span class="o">+</span><span class="nx">eventName</span><span class="p">]</span> <span class="o">=</span> <span class="p">(</span><span class="kd">function</span><span class="p">(</span><span class="nx">element</span><span class="p">,</span><span class="nx">eventName</span><span class="p">){</span></div><div class='line' id='LC60'>				<span class="k">return</span> <span class="kd">function</span><span class="p">(</span><span class="nx">event</span><span class="p">){</span></div><div class='line' id='LC61'>					<span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">trigger</span><span class="p">(</span><span class="nx">element</span><span class="p">,</span><span class="nx">eventName</span><span class="p">,</span><span class="nx">event</span><span class="p">);</span></div><div class='line' id='LC62'>				<span class="p">};</span></div><div class='line' id='LC63'>			<span class="p">})(</span><span class="nx">element</span><span class="p">,</span><span class="nx">eventName</span><span class="p">);</span></div><div class='line' id='LC64'>		<span class="p">},</span></div><div class='line' id='LC65'><br/></div><div class='line' id='LC66'>		<span class="cm">/**</span></div><div class='line' id='LC67'><span class="cm">		 * History.Adapter.trigger(el,event)</span></div><div class='line' id='LC68'><span class="cm">		 * @param {Element} element</span></div><div class='line' id='LC69'><span class="cm">		 * @param {String} eventName - custom and standard events</span></div><div class='line' id='LC70'><span class="cm">		 * @param {Object} event - a object of event data</span></div><div class='line' id='LC71'><span class="cm">		 * @return</span></div><div class='line' id='LC72'><span class="cm">		 */</span></div><div class='line' id='LC73'>		<span class="nx">trigger</span><span class="o">:</span> <span class="kd">function</span><span class="p">(</span><span class="nx">element</span><span class="p">,</span><span class="nx">eventName</span><span class="p">,</span><span class="nx">event</span><span class="p">){</span></div><div class='line' id='LC74'>			<span class="c1">// Prepare</span></div><div class='line' id='LC75'>			<span class="nx">event</span> <span class="o">=</span> <span class="nx">event</span> <span class="o">||</span> <span class="p">{};</span></div><div class='line' id='LC76'>			<span class="kd">var</span> <span class="nx">uid</span> <span class="o">=</span> <span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">uid</span><span class="p">(</span><span class="nx">element</span><span class="p">),</span></div><div class='line' id='LC77'>				<span class="nx">i</span><span class="p">,</span><span class="nx">n</span><span class="p">;</span></div><div class='line' id='LC78'><br/></div><div class='line' id='LC79'>			<span class="c1">// Apply Listener</span></div><div class='line' id='LC80'>			<span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">]</span> <span class="o">=</span> <span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">]</span> <span class="o">||</span> <span class="p">{};</span></div><div class='line' id='LC81'>			<span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">][</span><span class="nx">eventName</span><span class="p">]</span> <span class="o">=</span> <span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">][</span><span class="nx">eventName</span><span class="p">]</span> <span class="o">||</span> <span class="p">[];</span></div><div class='line' id='LC82'><br/></div><div class='line' id='LC83'>			<span class="c1">// Fire Listeners</span></div><div class='line' id='LC84'>			<span class="k">for</span> <span class="p">(</span> <span class="nx">i</span><span class="o">=</span><span class="mi">0</span><span class="p">,</span><span class="nx">n</span><span class="o">=</span><span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">][</span><span class="nx">eventName</span><span class="p">].</span><span class="nx">length</span><span class="p">;</span> <span class="nx">i</span><span class="o">&lt;</span><span class="nx">n</span><span class="p">;</span> <span class="o">++</span><span class="nx">i</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC85'>				<span class="nx">History</span><span class="p">.</span><span class="nx">Adapter</span><span class="p">.</span><span class="nx">handlers</span><span class="p">[</span><span class="nx">uid</span><span class="p">][</span><span class="nx">eventName</span><span class="p">][</span><span class="nx">i</span><span class="p">].</span><span class="nx">apply</span><span class="p">(</span><span class="k">this</span><span class="p">,[</span><span class="nx">event</span><span class="p">]);</span></div><div class='line' id='LC86'>			<span class="p">}</span></div><div class='line' id='LC87'>		<span class="p">},</span></div><div class='line' id='LC88'><br/></div><div class='line' id='LC89'>		<span class="cm">/**</span></div><div class='line' id='LC90'><span class="cm">		 * History.Adapter.extractEventData(key,event,extra)</span></div><div class='line' id='LC91'><span class="cm">		 * @param {String} key - key for the event data to extract</span></div><div class='line' id='LC92'><span class="cm">		 * @param {String} event - custom and standard events</span></div><div class='line' id='LC93'><span class="cm">		 * @return {mixed}</span></div><div class='line' id='LC94'><span class="cm">		 */</span></div><div class='line' id='LC95'>		<span class="nx">extractEventData</span><span class="o">:</span> <span class="kd">function</span><span class="p">(</span><span class="nx">key</span><span class="p">,</span><span class="nx">event</span><span class="p">){</span></div><div class='line' id='LC96'>			<span class="kd">var</span> <span class="nx">result</span> <span class="o">=</span> <span class="p">(</span><span class="nx">event</span> <span class="o">&amp;&amp;</span> <span class="nx">event</span><span class="p">[</span><span class="nx">key</span><span class="p">])</span> <span class="o">||</span> <span class="kc">undefined</span><span class="p">;</span></div><div class='line' id='LC97'>			<span class="k">return</span> <span class="nx">result</span><span class="p">;</span></div><div class='line' id='LC98'>		<span class="p">},</span></div><div class='line' id='LC99'><br/></div><div class='line' id='LC100'>		<span class="cm">/**</span></div><div class='line' id='LC101'><span class="cm">		 * History.Adapter.onDomLoad(callback)</span></div><div class='line' id='LC102'><span class="cm">		 * @param {Function} callback</span></div><div class='line' id='LC103'><span class="cm">		 * @return</span></div><div class='line' id='LC104'><span class="cm">		 */</span></div><div class='line' id='LC105'>		<span class="nx">onDomLoad</span><span class="o">:</span> <span class="kd">function</span><span class="p">(</span><span class="nx">callback</span><span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC106'>			<span class="kd">var</span> <span class="nx">timeout</span> <span class="o">=</span> <span class="nb">window</span><span class="p">.</span><span class="nx">setTimeout</span><span class="p">(</span><span class="kd">function</span><span class="p">(){</span></div><div class='line' id='LC107'>				<span class="nx">callback</span><span class="p">();</span></div><div class='line' id='LC108'>			<span class="p">},</span><span class="mi">2000</span><span class="p">);</span></div><div class='line' id='LC109'>			<span class="nb">window</span><span class="p">.</span><span class="nx">onload</span> <span class="o">=</span> <span class="kd">function</span><span class="p">(){</span></div><div class='line' id='LC110'>				<span class="nx">clearTimeout</span><span class="p">(</span><span class="nx">timeout</span><span class="p">);</span></div><div class='line' id='LC111'>				<span class="nx">callback</span><span class="p">();</span></div><div class='line' id='LC112'>			<span class="p">};</span></div><div class='line' id='LC113'>		<span class="p">}</span></div><div class='line' id='LC114'>	<span class="p">};</span></div><div class='line' id='LC115'><br/></div><div class='line' id='LC116'>	<span class="c1">// Try and Initialise History</span></div><div class='line' id='LC117'>	<span class="k">if</span> <span class="p">(</span> <span class="k">typeof</span> <span class="nx">History</span><span class="p">.</span><span class="nx">init</span> <span class="o">!==</span> <span class="s1">&#39;undefined&#39;</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC118'>		<span class="nx">History</span><span class="p">.</span><span class="nx">init</span><span class="p">();</span></div><div class='line' id='LC119'>	<span class="p">}</span></div><div class='line' id='LC120'><br/></div><div class='line' id='LC121'><span class="p">})(</span><span class="nb">window</span><span class="p">);</span></div></pre></div>
          </td>
        </tr>
      </table>
  </div>

          </div>
        </div>
      </div>
    </div>

  </div>

<div class="frame frame-loading large-loading-area" style="display:none;" data-tree-list-url="/balupton/history.js/tree-list/de8554b91e5a92840cefb63a6bba9a051fb39b66" data-blob-url-prefix="/balupton/history.js/blob/de8554b91e5a92840cefb63a6bba9a051fb39b66">
  <img src="https://a248.e.akamai.net/assets.github.com/images/spinners/octocat-spinner-64.gif?1329872007" height="64" width="64">
</div>

      </div>
      <div class="context-overlay"></div>
    </div>

      <div id="footer-push"></div><!-- hack for sticky footer -->
    </div><!-- end of wrapper - hack for sticky footer -->

      <!-- footer -->
      <div id="footer" >
        
  <div class="upper_footer">
     <div class="container clearfix">

       <!--[if IE]><h4 id="blacktocat_ie">GitHub Links</h4><![endif]-->
       <![if !IE]><h4 id="blacktocat">GitHub Links</h4><![endif]>

       <ul class="footer_nav">
         <h4>GitHub</h4>
         <li><a href="https://github.com/about">About</a></li>
         <li><a href="https://github.com/blog">Blog</a></li>
         <li><a href="https://github.com/features">Features</a></li>
         <li><a href="https://github.com/contact">Contact &amp; Support</a></li>
         <li><a href="https://github.com/training">Training</a></li>
         <li><a href="http://enterprise.github.com/">GitHub Enterprise</a></li>
         <li><a href="http://status.github.com/">Site Status</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Tools</h4>
         <li><a href="http://get.gaug.es/">Gauges: Analyze web traffic</a></li>
         <li><a href="http://speakerdeck.com">Speaker Deck: Presentations</a></li>
         <li><a href="https://gist.github.com">Gist: Code snippets</a></li>
         <li><a href="http://mac.github.com/">GitHub for Mac</a></li>
         <li><a href="http://mobile.github.com/">Issues for iPhone</a></li>
         <li><a href="http://jobs.github.com/">Job Board</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Extras</h4>
         <li><a href="http://shop.github.com/">GitHub Shop</a></li>
         <li><a href="http://octodex.github.com/">The Octodex</a></li>
       </ul>

       <ul class="footer_nav">
         <h4>Documentation</h4>
         <li><a href="http://help.github.com/">GitHub Help</a></li>
         <li><a href="http://developer.github.com/">Developer API</a></li>
         <li><a href="http://github.github.com/github-flavored-markdown/">GitHub Flavored Markdown</a></li>
         <li><a href="http://pages.github.com/">GitHub Pages</a></li>
       </ul>

     </div><!-- /.site -->
  </div><!-- /.upper_footer -->

<div class="lower_footer">
  <div class="container clearfix">
    <!--[if IE]><div id="legal_ie"><![endif]-->
    <![if !IE]><div id="legal"><![endif]>
      <ul>
          <li><a href="https://github.com/site/terms">Terms of Service</a></li>
          <li><a href="https://github.com/site/privacy">Privacy</a></li>
          <li><a href="https://github.com/security">Security</a></li>
      </ul>

      <p>&copy; 2012 <span title="0.05468s from fe12.rs.github.com">GitHub</span> Inc. All rights reserved.</p>
    </div><!-- /#legal or /#legal_ie-->

      <div class="sponsor">
        <a href="http://www.rackspace.com" class="logo">
          <img alt="Dedicated Server" height="36" src="https://a248.e.akamai.net/assets.github.com/images/modules/footer/rackspaces_logo.png?1329521040" width="38" />
        </a>
        Powered by the <a href="http://www.rackspace.com ">Dedicated
        Servers</a> and<br/> <a href="http://www.rackspacecloud.com">Cloud
        Computing</a> of Rackspace Hosting<span>&reg;</span>
      </div>
  </div><!-- /.site -->
</div><!-- /.lower_footer -->

      </div><!-- /#footer -->

    

<div id="keyboard_shortcuts_pane" class="instapaper_ignore readability-extra" style="display:none">
  <h2>Keyboard Shortcuts <small><a href="#" class="js-see-all-keyboard-shortcuts">(see all)</a></small></h2>

  <div class="columns threecols">
    <div class="column first">
      <h3>Site wide shortcuts</h3>
      <dl class="keyboard-mappings">
        <dt>s</dt>
        <dd>Focus site search</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>?</dt>
        <dd>Bring up this help dialog</dd>
      </dl>
    </div><!-- /.column.first -->

    <div class="column middle" style='display:none'>
      <h3>Commit list</h3>
      <dl class="keyboard-mappings">
        <dt>j</dt>
        <dd>Move selection down</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>k</dt>
        <dd>Move selection up</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>c <em>or</em> o <em>or</em> enter</dt>
        <dd>Open commit</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>y</dt>
        <dd>Expand URL to its canonical form</dd>
      </dl>
    </div><!-- /.column.first -->

    <div class="column last" style='display:none'>
      <h3>Pull request list</h3>
      <dl class="keyboard-mappings">
        <dt>j</dt>
        <dd>Move selection down</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>k</dt>
        <dd>Move selection up</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt>o <em>or</em> enter</dt>
        <dd>Open issue</dd>
      </dl>
      <dl class="keyboard-mappings">
        <dt><span class="platform-mac">⌘</span><span class="platform-other">ctrl</span> <em>+</em> enter</dt>
        <dd>Submit comment</dd>
      </dl>
    </div><!-- /.columns.last -->

  </div><!-- /.columns.equacols -->

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Issues</h3>

    <div class="columns threecols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt>j</dt>
          <dd>Move selection down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>k</dt>
          <dd>Move selection up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>x</dt>
          <dd>Toggle selection</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>o <em>or</em> enter</dt>
          <dd>Open issue</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="platform-mac">⌘</span><span class="platform-other">ctrl</span> <em>+</em> enter</dt>
          <dd>Submit comment</dd>
        </dl>
      </div><!-- /.column.first -->
      <div class="column last">
        <dl class="keyboard-mappings">
          <dt>c</dt>
          <dd>Create issue</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>l</dt>
          <dd>Create label</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>i</dt>
          <dd>Back to inbox</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>u</dt>
          <dd>Back to issues</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>/</dt>
          <dd>Focus issues search</dd>
        </dl>
      </div>
    </div>
  </div>

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Issues Dashboard</h3>

    <div class="columns threecols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt>j</dt>
          <dd>Move selection down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>k</dt>
          <dd>Move selection up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>o <em>or</em> enter</dt>
          <dd>Open issue</dd>
        </dl>
      </div><!-- /.column.first -->
    </div>
  </div>

  <div style='display:none'>
    <div class="rule"></div>

    <h3>Network Graph</h3>
    <div class="columns equacols">
      <div class="column first">
        <dl class="keyboard-mappings">
          <dt><span class="badmono">←</span> <em>or</em> h</dt>
          <dd>Scroll left</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">→</span> <em>or</em> l</dt>
          <dd>Scroll right</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">↑</span> <em>or</em> k</dt>
          <dd>Scroll up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt><span class="badmono">↓</span> <em>or</em> j</dt>
          <dd>Scroll down</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>t</dt>
          <dd>Toggle visibility of head labels</dd>
        </dl>
      </div><!-- /.column.first -->
      <div class="column last">
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">←</span> <em>or</em> shift h</dt>
          <dd>Scroll all the way left</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">→</span> <em>or</em> shift l</dt>
          <dd>Scroll all the way right</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">↑</span> <em>or</em> shift k</dt>
          <dd>Scroll all the way up</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>shift <span class="badmono">↓</span> <em>or</em> shift j</dt>
          <dd>Scroll all the way down</dd>
        </dl>
      </div><!-- /.column.last -->
    </div>
  </div>

  <div >
    <div class="rule"></div>
    <div class="columns threecols">
      <div class="column first" >
        <h3>Source Code Browsing</h3>
        <dl class="keyboard-mappings">
          <dt>t</dt>
          <dd>Activates the file finder</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>l</dt>
          <dd>Jump to line</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>w</dt>
          <dd>Switch branch/tag</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>y</dt>
          <dd>Expand URL to its canonical form</dd>
        </dl>
      </div>
    </div>
  </div>

  <div style='display:none'>
    <div class="rule"></div>
    <div class="columns threecols">
      <div class="column first">
        <h3>Browsing Commits</h3>
        <dl class="keyboard-mappings">
          <dt><span class="platform-mac">⌘</span><span class="platform-other">ctrl</span> <em>+</em> enter</dt>
          <dd>Submit comment</dd>
        </dl>
        <dl class="keyboard-mappings">
          <dt>escape</dt>
          <dd>Close form</dd>
        </dl>
      </div>
    </div>
  </div>
</div>

    <div id="markdown-help" class="instapaper_ignore readability-extra">
  <h2>Markdown Cheat Sheet</h2>

  <div class="cheatsheet-content">

  <div class="mod">
    <div class="col">
      <h3>Format Text</h3>
      <p>Headers</p>
      <pre>
# This is an &lt;h1&gt; tag
## This is an &lt;h2&gt; tag
###### This is an &lt;h6&gt; tag</pre>
     <p>Text styles</p>
     <pre>
*This text will be italic*
_This will also be italic_
**This text will be bold**
__This will also be bold__

*You **can** combine them*
</pre>
    </div>
    <div class="col">
      <h3>Lists</h3>
      <p>Unordered</p>
      <pre>
* Item 1
* Item 2
  * Item 2a
  * Item 2b</pre>
     <p>Ordered</p>
     <pre>
1. Item 1
2. Item 2
3. Item 3
   * Item 3a
   * Item 3b</pre>
    </div>
    <div class="col">
      <h3>Miscellaneous</h3>
      <p>Images</p>
      <pre>
![GitHub Logo](/images/logo.png)
Format: ![Alt Text](url)
</pre>
     <p>Links</p>
     <pre>
http://github.com - automatic!
[GitHub](http://github.com)</pre>
<p>Blockquotes</p>
     <pre>
As Kanye West said:

> We're living the future so
> the present is our past.
</pre>
    </div>
  </div>
  <div class="rule"></div>

  <h3>Code Examples in Markdown</h3>
  <div class="col">
      <p>Syntax highlighting with <a href="http://github.github.com/github-flavored-markdown/" title="GitHub Flavored Markdown" target="_blank">GFM</a></p>
      <pre>
```javascript
function fancyAlert(arg) {
  if(arg) {
    $.facebox({div:'#foo'})
  }
}
```</pre>
    </div>
    <div class="col">
      <p>Or, indent your code 4 spaces</p>
      <pre>
Here is a Python code example
without syntax highlighting:

    def foo:
      if not bar:
        return true</pre>
    </div>
    <div class="col">
      <p>Inline code for comments</p>
      <pre>
I think you should use an
`&lt;addr&gt;` element here instead.</pre>
    </div>
  </div>

  </div>
</div>


    <div class="ajax-error-message">
      <p><span class="icon"></span> Something went wrong with that request. Please try again. <a href="javascript:;" class="ajax-error-dismiss">Dismiss</a></p>
    </div>

    <div id="logo-popup">
      <h2>Looking for the GitHub logo?</h2>
      <ul>
        <li>
          <h4>GitHub Logo</h4>
          <a href="http://github-media-downloads.s3.amazonaws.com/GitHub_Logos.zip"><img alt="Github_logo" src="https://a248.e.akamai.net/assets.github.com/images/modules/about_page/github_logo.png?1315937721" /></a>
          <a href="http://github-media-downloads.s3.amazonaws.com/GitHub_Logos.zip" class="minibutton btn-download download"><span><span class="icon"></span>Download</span></a>
        </li>
        <li>
          <h4>The Octocat</h4>
          <a href="http://github-media-downloads.s3.amazonaws.com/Octocats.zip"><img alt="Octocat" src="https://a248.e.akamai.net/assets.github.com/images/modules/about_page/octocat.png?1315937721" /></a>
          <a href="http://github-media-downloads.s3.amazonaws.com/Octocats.zip" class="minibutton btn-download download"><span><span class="icon"></span>Download</span></a>
        </li>
      </ul>
    </div>

    
    
    
    <span id='server_response_time' data-time='0.05775' data-host='fe12'></span>
  </body>
</html>

