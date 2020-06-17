// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

import 'bootstrap'
import coreui from '../node_modules/@coreui/coreui/dist/js/coreui.bundle.min.js'
import formBuilder from 'formBuilder'

import $ from 'jquery'

window.jQuery = $
window.$ = $

window.coreui = coreui
window.formBuilder = formBuilder