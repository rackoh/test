class Student < ApplicationRecord

  belongs_to :classroom

  validates :name, :admission_year, :classroom_id, presence: true
  validates :name, length: { maximum: 150 }
  validate  :valid_admission_year

  scope :active_student, -> { where(active: true) }
  scope :inactive_student, -> { where(active: false) }
  scope :after_year, -> { where('student.admission_year > ?', admission_year) }

  private 
    def valid_admission_year
      unless self.admission_year.between? 1900, 2018
        self.errors.add(:admission_year, "It should be in range 1900 to 2018")
      end
    end

end
