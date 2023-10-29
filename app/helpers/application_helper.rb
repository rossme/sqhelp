module ApplicationHelper

  FLASH_LEVELS = {
    notice: 'info',
    success: 'success',
    error: 'danger',
    alert: 'warning'
  }.freeze

  def flash_class(level)
    FLASH_LEVELS[level&.to_sym].presence
  end

  def github_release_details
    # Check if the personal access token has expired, Octokit then raises an exception
    return I18n.t('application.release_details.error') unless latest_release && latest_deploy

    I18n.t('application.release_details.info', latest_release: latest_release, latest_deploy: latest_deploy)
  end

  # `rails dev:cache` toggles caching in development environment
  def latest_release
    Rails.cache.fetch('latest_release', expires_in: 12.hours) do
#       Octokit.latest_release('rossme/sqhelp')&.tag_name
    end
  rescue Octokit::Unauthorized, Octokit::TooManyRequests
    nil # this error is handled in github_release_details
  end

  # `rails dev:cache` toggles caching in development environment
  def latest_deploy
    Rails.cache.fetch('latest_deploy', expires_in: 12.hours) do
#       Octokit.deployments('rossme/sqhelp').first[:updated_at]
    end
  rescue Octokit::Unauthorized, Octokit::TooManyRequests
    nil # this error is handled in github_release_details
  end
end
