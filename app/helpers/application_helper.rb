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
end
