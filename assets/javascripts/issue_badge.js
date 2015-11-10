// call issue_badge
function load_badge(url) {
    $.ajax({
        url: url,
        async: true,
        type: 'get'
    }).done(function( html ) {
        $('#loggedas').after(html);
    });
}

function display_badge_contents(url) {
    console.log('clicked.....');
    $.ajax({
        url: url,
        async: true,
        type: 'get'
    }).done(function( html ) {
        $('#link_issue_badge').after(html);
    });
}

$(document).click(function(event) {
    if (!$.contains($("#issue_badge_contents")[0], event.target)) {
        $("#issue_badge_contents").hide();
        $("#issue_badge_contents").remove();
    }
});