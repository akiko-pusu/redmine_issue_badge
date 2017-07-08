// call issue_badge
function load_badge(url) {
    $.ajax({
        url: url,
        async: true,
        type: 'get'
    }).done(function( html ) {
        if ($(html).filter('div#issue_badge').length || $(html).filter('div#issue_badge0').length) {
            $('#loggedas').after(html);
        }
    });
}

function display_badge_goto(url) {
    window.location.href=url
}


function display_badge_contents(url) {
    $.ajax({
        url: url,
        async: true,
        type: 'get'
    }).done(function( html ) {
        $('#link_issue_badge').after(html);
    });
}

function change_badge_location() {
    if (window.matchMedia( '(max-width: 899px)' ).matches) {
        $('#quick-search').prepend($('#issue_badge'));
    } else {
        $('#loggedas').after($('#issue_badge'));
    }
}

function change_badge_location2(num) {
    for (i=0;i<num;++i)
    {
        if (window.matchMedia( '(max-width: 899px)' ).matches) {
            $('#quick-search').prepend($('#issue_badge'+i));
        } else {
            $('#loggedas').after($('#issue_badge'+i));
        }
    }
}
$(document).click(function(event) {
    // Hide if badge_contents exists.
    if (!$(event.target).is("#issue_badge_contents")) {
        $("#issue_badge_contents").hide();
        $("#issue_badge_contents").remove();
    }
});
