// call issue_badge
/* eslint-disable no-unused-vars */
/* eslint-env jquery */
const loadBadge = (url, optionPollUrl) => {
  baseRequest(url)
    .then((html) => {
      if (html.length > 0) {
        document.getElementById('loggedas').insertAdjacentHTML('afterend', html)
        changeBadgeLocation()
        if (optionPollUrl) {
          pollBadgeCount(optionPollUrl)
        }
      }
    })
}

// Load and popup BadgeContents
const displayBadgeContents = (url) => {
  baseRequest(url).then((html) => {
    if (html.length > 0) {
      document.getElementById('link_issue_badge').insertAdjacentHTML('afterend', html)
    }
  }).catch(() => { /* do nothing */ })
}

// Hide BadgeContents
document.addEventListener('click', (event) => {
  const badgeContents = document.getElementById('issue_badge_contents')

  if (badgeContents && event.target !== badgeContents) {
    badgeContents.remove()
  }
})

// Polling setting
const pollBadgeCount = (pollingUrl) => {
  const poll = (pollingUrl) => {
    let status = document.getElementById('issue_badge_number')
    baseRequest(pollingUrl, 'json')
      .then((data) => {
        if (typeof data.all_issues_count !== 'undefined' && data.status === true) {
          status.textContent = data.all_issues_count
        } else {
          status.textContent = '?'
          clearInterval(pollInterval)
        }
      })
      .catch(() => {
        // Stop polling and resolve
        clearInterval(pollInterval)
      })
  }
  const pollInterval = setInterval(poll, 10000, pollingUrl)
}

// For responsive: change the place to display badge
const changeBadgeLocation = () => {
  const issueBadgeElement = document.getElementById('issue_badge')
  if (window.matchMedia('(max-width: 899px)').matches) {
    const quickSearch = document.getElementById('quick-search')
    if (quickSearch) {
      quickSearch.insertBefore(issueBadgeElement, quickSearch.firstChild)
    }
  } else {
    const loggedas = document.getElementById('loggedas')
    if (loggedas) {
      loggedas.insertAdjacentElement('afterend', issueBadgeElement)
    }
  }
}

window.onresize = () => {
  changeBadgeLocation()
}

// Common method to send request and return response text
const baseRequest = (url, type) => {
  return new Promise((resolve, reject) => {
    let request = new window.XMLHttpRequest()
    request.open('GET', url, true)

    if (type) {
      request.responseType = type
    }

    request.onload = () => {
      // Only update nadge when success. Do nothing when status is error.
      if (request.status >= 200 && request.status < 400) {
        resolve(request.response)
      } else {
        reject(new Error(request.statusText))
      }
    }

    request.onerror = () => {
      reject(new Error(request.statusText))
    }
    request.send()
  })
}

/* eslint-enable no-unused-vars */
