// call issue_badge
function load_badge(url) {
    $.ajax({
        url: url,
        async: true,
        type: 'get'
    }).done(function( html ) {
        if ($(html).filter('div#issue_badge').length) {
            $('#loggedas').after(html);
        }
    });
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

$(document).click(function(event) {
    // Hide if badge_contents exists.
    if (!$(event.target).is("#issue_badge_contents")) {
        $("#issue_badge_contents").hide();
        $("#issue_badge_contents").remove();
    }
});

var status = $('#issue_badge_number');
function poll(url) {
    var status = $('#issue_badge_number');
        $.ajax({
            url: url,
            dataType: 'json',
            type: 'get',
            success: function(data) {
                if (typeof data.all_issues_count !== "undefined" && data.status == true) {
                    status.text(data.all_issues_count);
                } else {
                    console.log("[IssueBadge] Error. Can't parse polling data.");
                    status.text("?");
                    clearInterval(pollInterval);
                }
            },
            error: function() {
                console.log("[IssueBadge] Error. Ajax request failed.");
                clearInterval(pollInterval);
            }
        });
    }