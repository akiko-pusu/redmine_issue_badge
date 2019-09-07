// call issue_badge
/* eslint-disable no-unused-vars */
/* eslint-env jquery */
const loadBadge = (url, optionPollUrl) => {
  let request = new window.XMLHttpRequest()
  request.open('GET', url, true)

  request.onload = () => {
    // Only update nadge when success. Do nothing when status is error.
    if (request.status >= 200 && request.status < 400) {
      let html = request.response
      if (html.length > 0) {
        document.getElementById('loggedas').insertAdjacentHTML('afterend', html)
        if (optionPollUrl) {
          pollBadgeCount(optionPollUrl)
        }
        changeBadgeLocation()
      }
    }
  }

  request.onerror = () => {
    // do nothing
  }
  request.send()
}

const displayBadgeContents = (url) => {
  let request = new window.XMLHttpRequest()
  request.open('GET', url, true)

  request.onload = () => {
    // Only update contents when success. Do nothing when status is error.
    if (request.status >= 200 && request.status < 400) {
      let html = request.response
      if (html.length > 0) {
        document.getElementById('link_issue_badge').insertAdjacentHTML('afterend', html)
      }
    }
  }

  request.onerror = () => {
    // do nothing
  }
  request.send()
}

const changeBadgeLocation = () => {
  const issueBadgeElement = document.getElementById('issue_badge')
  if (window.matchMedia('(max-width: 899px)').matches) {
    const quickSearch = document.getElementById('quick-search')

    quickSearch.insertBefore(issueBadgeElement, quickSearch.firstChild)
  } else {
    document.getElementById('loggedas').insertAdjacentElement('afterend', issueBadgeElement)
  }
}

document.addEventListener('click', (event) => {
  const badgeContents = document.getElementById('issue_badge_contents')

  if (badgeContents && event.target !== badgeContents) {
    badgeContents.remove()
  }
})

window.onresize = () => {
  changeBadgeLocation()
}

// Polling setting
const pollBadgeCount = (pollingUrl) => {
  const poll = (pollingUrl) => {
    let status = document.getElementById('issue_badge_number')
    let request = new window.XMLHttpRequest()

    request.open('GET', pollingUrl, true)

    request.onload = () => {
      // Only update issue count when success. Do nothing when status is error and stop polling.
      if (request.status >= 200 && request.status < 400) {
        let data = request.response
        if (typeof data.all_issues_count !== 'undefined' && data.status === true) {
          status.textContent = data.all_issues_count
        } else {
          status.textContent = '?'
          clearInterval(pollInterval)
        }
      } else {
        clearInterval(pollInterval)
      }
    }

    request.onerror = () => {
      // do nothing
    }
    request.responseType = 'json'
    request.send()
  }
  const pollInterval = setInterval(poll, 60000, pollingUrl)
}

/* eslint-enable no-unused-vars */
