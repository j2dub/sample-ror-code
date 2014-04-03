class Circle < ActiveRecord::Base
     attr_accessible :name, :public, :id, :created_at, :user_id, :deleted, :deleted_at

     
     belongs_to :user, :class_name => "User", :foreign_key => 'user_id'
     has_many :circlerelationships, foreign_key: "circle_id", dependent: :destroy
     has_many :circled_items, through: :relationships, source: :circled
	 has_many :reverse_circlerelationships, foreign_key: "circle_id",
									   class_name:  "Circlerelationship",
									   dependent:   :destroy
	 has_many :circlers, through: :reverse_circlerelationships, source: :circler   
	   
        
     validates :user_id, :presence => true
     validates :name, :presence => true,
               :length   => { :maximum => 40 },
               :length   => { :minimum => 5 },
               :uniqueness => { :case_sensitive => false, :scope => [:user_id] }
               
	validates_uniqueness_of :name, :scope => :user_id              
     
     default_scope order: 'circles.created_at DESC'
     
     # Return items from the users being followed by the given user.
     scope :from_users_listed_by, lambda { |user| listed_by(user) }
     

	  def circling?(other_circle)
		circlerelationships.find_by_circled_id(other_circle.id)
	  end

	  def circle!(other_item)
		circlerelationships.create!(circled_id: other_item.id)
	  end
	  
	  def uncircle!(other_item)
		circlerelationships.find_by_circled_id(other_item.id).destroy
	  end	  
    
    def mark_deleted
	  self.deleted_at = Time.now
	  self.deleted_at = 'Y'
	end
	 
	def mark_deleted!
	  mark_deleted
	  self.save
	end

		  private

			# Return an SQL condition for users followed by the given user.
			# We include the user's own id as well.
			def self.listing_by(user)
			  listing_ids = %(SELECT name, id FROM circles
								WHERE user_id = :user_id)
			  where("user_id IN (#{listing_ids}) OR user_id = :user_id",
					{ :user_id => user })
			end     
     
 
end
