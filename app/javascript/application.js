// Entry point for the build script in your package.json
import { Turbo } from "@hotwired/turbo-rails"

import "./controllers"
import "./turbo_streams"

import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap

