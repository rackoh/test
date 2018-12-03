class Classroom < ApplicationRecord
  
  has_many :students, dependent: :destroy

  validates :name, :code, presence: true
  validates :code, uniqueness: true 
                                    
end
