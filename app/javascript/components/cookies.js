const initCookieBanner = () => {
  const cookiesBanner = document.getElementById("cookiesBanner");
  const cookiesGlobalConsentBtn = document.getElementById("cookiesGlobalConsent"); // "Accepter" button in cookies banner
  const cookiesConfigBtn = document.getElementById("cookiesConfigBtn"); // "Je valide" button in modal
  const googleAnalyticsBtn = document.getElementById("google_analytics_consent");
  const gaKey = googleAnalyticsBtn.dataset.analytics;
  const optOutCookieName = 'ga-disable-' + gaKey;

  const hideCookiesBanner = () => {
    cookiesBanner.classList.add("d-none");
  }
  const showCookiesBanner = () => {
    cookiesBanner.classList.remove("d-none");
  }

  const setCookie = (name, value, months) => {
    let expirationDate = new Date;
    expirationDate.setMonth(expirationDate.getMonth() + months);
    document.cookie = name + "=" + value + ";path=/;expires=" + expirationDate.toGMTString();
  }
  const saveCookiesPreferences = (googleAnalyticsRefused) => {
    setCookie("cookies-preferences-given", "true", 12);
    setCookie(optOutCookieName, `${googleAnalyticsRefused}`, 12); // Sets cookie if does not exist already
    window[optOutCookieName] = googleAnalyticsRefused; // Updates cookie value if already exists
    hideCookiesBanner();
  }
  if (document.cookie.indexOf('cookies-preferences-given=true') == -1) {
    showCookiesBanner();
  } else {
    googleAnalyticsBtn.checked = (document.cookie.indexOf(optOutCookieName + '=false') != -1);
  }

  cookiesGlobalConsentBtn.addEventListener("click", (e) => {
    googleAnalyticsBtn.checked = true;
    saveCookiesPreferences(!googleAnalyticsBtn.checked)
  })

  cookiesConfigBtn.addEventListener("click", (e)=>{
    saveCookiesPreferences(!googleAnalyticsBtn.checked)
  })
}
export { initCookieBanner };
