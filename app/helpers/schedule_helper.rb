module ScheduleHelper

  def human_time_range(submission)
    "#{submission.start_hour.hours.since(Date.today.beginning_of_day).strftime('%l:%M%P')} &mdash; #{submission.end_hour.hours.since(Date.today.beginning_of_day).strftime('%l:%M%P')}".html_safe
  end

  def formatted_start_date_for_index(index, format = '%B %-d, %Y')
    (ActiveSupport::TimeZone.new('America/Denver').local(2015, 9, 28).at_beginning_of_day + index.days).strftime(format)
  end

  def registered_for_session?(submission)
    registered? && current_registration.submission_ids.include?(submission.id)
  end

end
