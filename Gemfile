# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

# Inside the development app, the relative require has to be one level up, as
# the Gemfile is copied to the development_app folder (almost) as is.
module_path = ""
module_path = "../" if File.basename(__dir__) == "development_app"
require_relative "#{module_path}lib/decidim/action_delegator/version"

DECIDIM_VERSION = Decidim::ActionDelegator::DECIDIM_VERSION

# Optional local override for Decidim — set DECIDIM_PATH to a local checkout to
# develop against an in-progress Decidim. Defaults to rubygems otherwise.
decidim_path = ENV.fetch("DECIDIM_PATH", nil)

if decidim_path
  decidim_args = [{ path: decidim_path }]
  decidim_elections_args = [{ path: "#{decidim_path}/decidim-elections" }]
  decidim_initiatives_args = [{ path: "#{decidim_path}/decidim-initiatives" }]
  decidim_dev_args = [{ path: "#{decidim_path}/decidim-dev" }]
else
  decidim_args = Array(DECIDIM_VERSION)
  decidim_elections_args = Array(DECIDIM_VERSION)
  decidim_initiatives_args = Array(DECIDIM_VERSION)
  decidim_dev_args = Array(DECIDIM_VERSION)
end

gem "puma", ">= 6.3.1"

gem "decidim", *decidim_args
gem "decidim-action_delegator", path: module_path.empty? ? "." : module_path
gem "decidim-elections", *decidim_elections_args
gem "decidim-initiatives", *decidim_initiatives_args

gem "bootsnap", "~> 1.23"

group :development, :test do
  gem "byebug", "~> 13.0", platform: :mri

  gem "brakeman", "~> 8.0"
  gem "decidim-dev", *decidim_dev_args
  gem "parallel_tests", "~> 5.6"
end

group :development do
  gem "letter_opener_web", "~> 3.0"
  gem "listen", "~> 3.10"
  gem "web-console", "~> 4.3"
end

group :test do
  gem "shoulda-matchers"
end
