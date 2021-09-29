require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

var Turbolinks = require("turbolinks")
Turbolinks.start()
// External imports
import "bootstrap";

// Internal imports
import { initCookieBanner } from '../components/cookies'
import { initMapbox } from '../plugins/init_mapbox';
// import "controllers" TODO  waiting for debug

document.addEventListener('turbolinks:load', () => {
  initCookieBanner();
  initMapbox();
});
