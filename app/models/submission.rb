class Submission < ActiveRecord::Base

  attr_accessible :day, :description, :format, :location, :notes, :time_range, :title, :track_id, :contact_email, :estimated_size

  FORMATS = [ 'Presentation',
              'Panel',
              'Workshop',
              'Social event' ]

  DAYS =  [ 'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Weekend before',
            'Weekend after' ]

  TIME_RANGES = [ 'Early morning',
                  'Breakfast',
                  'Morning',
                  'Lunch',
                  'Early afternoon',
                  'Afternoon',
                  'Happy hour',
                  'Evening',
                  'Late night' ]

  belongs_to :submitter, class_name: 'User'
  belongs_to :track

  validates :title, presence: true
  validates :description, presence: true
  validates :contact_email, presence: true
  validates :format,  presence: true,
                      inclusion: { in: FORMATS,
                                   allow_nil: true }
  validates :day,  presence: true,
                      inclusion: { in: DAYS,
                                   allow_nil: true }
  validates :time_range,  presence: true,
                      inclusion: { in: TIME_RANGES,
                                   allow_nil: true }
  validates :track_id, presence: true

  after_create :notify_track_chair

  def notify_track_chair
    if chair = self.track.chair
      NotificationsMailer.notify_of_new_submission(chair, self).deliver
    else
      binding.pry
      Rails.logger.info self.track.inspect
      Rails.logger.error "*** No chair exists for the #{self.track.name} track, unable to notify"
    end
  end

end
