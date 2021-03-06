class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :membership
  has_one :user, through: :membership

  has_one :cohort, through: :event

  scope :unmarked, -> { where(status: nil)}
  scope :due, -> { includes(:event).references(:event).where("events.date <= ?", DateTime.now)}
  scope :todo, -> { due.unmarked }


  def date
    self.event.date.strftime("%a, %m/%d/%y")
  end

  # TODO: this should use activerecord enums maybe -ab
  def self.statuses
    {
      nil => "n/a",
      0 => "Absent",
      1 => "Tardy",
      2 => "Present"
    }
  end

  def status_english
    return Attendance.statuses[self.status]
  end
end
