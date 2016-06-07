// VimFx config

console.log("Loading vimfx config ...");

// Customize the existing keys
vimfx.set("mode.normal.focus_search_bar", "s");
vimfx.set("mode.normal.stop", "<c-c>");
vimfx.set("mode.normal.stop_all", "a<c-c>");
vimfx.set("mode.normal.scroll_half_page_down", "<c-d>");
vimfx.set("mode.normal.scroll_half_page_up", "<c-u>");
vimfx.set("mode.normal.history_back", "<c-o>");
vimfx.set("mode.normal.history_forward", "<c-i>");
vimfx.set("mode.normal.tab_close", "d");
vimfx.set("mode.normal.tab_restore", "D");

var getPbFx = function () {
    var contractId = '@parantapa.net/pbfx';

    var pbfx = Components.classes[contractId].
               getService(Components.interfaces.nsISupports).
               wrappedJSObject;

    return pbfx;
}

var addQuickOpenCmd = function (name, desc, key, urls) {
    var i;

    var newUrls = [];
    for (i = 0; i < urls.length; i++) {
        newUrls.push("http://" + urls[i]);
    }

    vimfx.addCommand(
        {name: name, description: desc},
        function () { getPbFx().openUrls(newUrls) }
    );

    vimfx.set("custom.mode.normal." + name, key);
};

addQuickOpenCmd("open_gmail", "Open Gmail", ",m",
    ["gmail.com"]);
addQuickOpenCmd("open_gcal", "Open Google Calendar", ",v",
    ["google.com/calendar"]);
addQuickOpenCmd("open_gs", "Open Google Scholar", ",gs",
    ["google.com/scholar"]);
addQuickOpenCmd("open_news", "Open News Sites", ",n",
    ["news.ycombinator.com", "google.com/news"]);
addQuickOpenCmd("open_social", "Open Social Network Sites", ",s",
    ["facebook.com", "twitter.com", "reddit.com"]);
addQuickOpenCmd("open_blogs", "Open Blogs", ",b",
    ["lifehacker.com", "boingboing.net"]);
addQuickOpenCmd("open_comics_a", "Open Comics", ",c1",
    ["dilbert.com",
     "xkcd.com",
     "phdcomics.com/comics.php",
     "www.commitstrip.com/en/"]);
addQuickOpenCmd("open_comics_b", "Open Comics", ",c2",
    ["gocomics.com/calvinandhobbes",
     "gocomics.com/garfield",
     "gocomics.com/broomhilda",
     "gocomics.com/bc",
     "gocomics.com/wizardofid"]);
addQuickOpenCmd("open_comics_c", "Open Comics", ",c3",
    ["arcamax.com/thefunnies/hagarthehorrible",
     "arcamax.com/thefunnies/beetlebailey",
     "arcamax.com/thefunnies/peanuts"]);

