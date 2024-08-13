# frozen_string_literal: true

# Pagy initializer file (8.2.0)
Pagy::DEFAULT[:items]       = 10                    # default

# Frontend Extras
# Bootstrap extra: Add nav, nav_js and combo_nav_js helpers and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/docs/extras/bootstrap
require 'pagy/extras/bootstrap'

# I18n
Pagy::I18n.load(locale: 'es')
require 'pagy/extras/i18n'

# When you are done setting your own default freeze it, so it will not get changed accidentally
Pagy::DEFAULT.freeze
