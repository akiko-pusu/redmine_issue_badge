// call issue_badge
/* eslint-disable no-unused-vars */
/* eslint-env jquery */
const loadBadge = (url) => {
  let request = new window.XMLHttpRequest()
  request.open('GET', url, true)

  request.onload = () => {
    if (request.status >= 200 && request.status < 400) {
      let html = request.response
      if (html.length > 0) {
        $('#loggedas').after(html)
      }
    } else {
      console.log('[IssueBadge] LoadBadge Response Error. Status: ' + request.status)
    }
  }

  request.onerror = () => {
    console.log("[IssueBadge] LoadBadge Request Error. Can't get badge data.")
  }
  request.send()
}

const displayBadgeContents = (url) => {
  let request = new window.XMLHttpRequest()
  request.open('GET', url, true)

  request.onload = () => {
    if (request.status >= 200 && request.status < 400) {
      let html = request.response
      if (html.length > 0) {
        document.getElementById('link_issue_badge').insertAdjacentHTML('afterend', html)
      }
    } else {
      console.log('[IssueBadge] DisplayBadge Error. Status: ' + request.status)
    }
  }

  request.onerror = () => {
    console.log("[IssueBadge] DisplayBadge Request Error. Can't get badge data.")
  }
  request.send()
}

const changeBadgeLocation = () => {
  const issueBadgeElement = document.getElementById('issue_badge')
  if (window.matchMedia('(max-width: 899px)').matches) {
    $('#quick-search').prepend($('#issue_badge'))
  } else {
    $('#loggedas').after($('#issue_badge'))
  }
}

document.addEventListener('click', function (event) {
  if (!$(event.target).is('#issue_badge_contents')) {
    $('#issue_badge_contents').hide()
    $('#issue_badge_contents').remove()
  }
})

/* eslint-enable no-unused-vars */
