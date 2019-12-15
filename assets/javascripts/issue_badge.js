// call issue_badge
/* eslint-disable no-unused-vars */
/* eslint-env jquery */
const badgeTemplate = `
<div id="issue_badge">
  <li class="starting_point">
    <a style="cursor: pointer" onclick="displayBadgeContents();" id="link_issue_badge" data-content_path="">
      <span id="issue_badge_number" class="badge red"></span>
    </a>
  </li>
</div>
`

const loadBadge = (url, optionPollUrl) => {
  baseRequest(url, 'json').then((data) => {
    document.getElementById('loggedas').insertAdjacentHTML('afterend', badgeTemplate)
    changeBadgeLocation()
    let status = document.getElementById('issue_badge_number')
    let badgeLink = document.getElementById('link_issue_badge')
    document.getElementById('issue_badge').style.display = 'block'
    if (typeof data.all_issues_count !== 'undefined' && data.status === true) {
      status.textContent = data.all_issues_count
      status.className = 'badge ' + data.badge_color
      badgeLink.dataset.content_path = data.content_path
    } else {
      status.textContent = '?'
    }
    if (optionPollUrl) {
      pollBadgeCount(optionPollUrl)
    }
  }).catch(() => { /* do nothing */ })
}

// Load and popup BadgeContents
const displayBadgeContents = () => {
  let url = document.getElementById('link_issue_badge').dataset.content_path
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
        document.getElementById('issue_badge').style.display = 'block'
        let badgeLink = document.getElementById('link_issue_badge')
        if (typeof data.all_issues_count !== 'undefined' && data.status === true) {
          status.textContent = data.all_issues_count
          status.className = 'badge ' + data.badge_color
          badgeLink.dataset.content_path = data.content_path
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
  const pollInterval = setInterval(poll, 60000, pollingUrl)
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
