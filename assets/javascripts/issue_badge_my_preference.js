// call issue_badge
/* eslint-disable no-unused-vars */
/* eslint-env jquery */
/* --------- My preference Page ----------- */

const changePrefLocation = () => {
  const element = document.getElementById('pref_issue_badge')
  const target = document.querySelector('div.splitcontentright')

  if (window.matchMedia('(max-width: 899px)').matches) {
    const mobileTarget = target.querySelector('p.mobile-show')
    target.insertBefore(element, mobileTarget)
  } else {
    target.appendChild(element)
  }
}

const showOptionalBadgeSetting = () => {
  toggleItem('show_assigned_to_group')
  toggleItem('badge_order')
}

const toggleItem = (id) => {
  const element = document.getElementById(id)

  let style = element.style.display
  element.style.display = (style === 'block') ? 'none' : 'block'
}

window.onload = () => {
  changePrefLocation()
}

window.onresize = () => {
  changePrefLocation()
}

/* eslint-enable no-unused-vars */
