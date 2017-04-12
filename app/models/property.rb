class Property < ApplicationRecord

  acts_as_paranoid

  serialize :net_nature_of_lease, Array

  attr_accessor :ostatus

  include MyFunction
  has_many :comments, as: :commentable
  has_many :procedures
  has_many :parcels
  accepts_nested_attributes_for :parcels, :reject_if => :all_blank

  alias_attribute :name, :title

  validates_presence_of :title

  after_create :access_resource
  after_save :add_key
  belongs_to :transaction_sale
  before_save :check_price_current_rent_cap_rate

  TYPES = ['Single Tenant Freestanding', 'Shopping Center',
           'Office Building', 'Apartment Building', 'Industrial',
           'Agricultural', 'Other']

  def access_resources
    AccessResource.where(resource_klass: self.class.to_s, resource_id: self.id)
  end

  def projects_form_build
    build = []
    TransactionSale.all.each do |project|
      build << ["#{project.client.try(:name)}::#{project.title}", project.id]
    end
    build
  end
  
  def check_price_current_rent_cap_rate
    if !self.cap_rate.present? && self.price.present? && self.current_rent.present?
      self.cap_rate = (self.current_rent * 100.0)/(self.price * 1.0)
      return
    elsif !self.price.present? && self.cap_rate.present? && self.current_rent.present?
      self.price = (self.current_rent * 100.0)/(self.cap_rate * 1.0)
      return
    elsif !self.current_rent.present? && self.cap_rate.present? && self.price.present?
      self.current_rent = (self.cap_rate * self.price * 1.0)/100.0
      return
    end
  end

  US_STATES =
    ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut',
     'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois Indiana', 'Iowa',
     'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan',
     'Minnesota', 'Mississippi', 'Missouri', 'Montana Nebraska', 'Nevada', 'New Hampshire',
     'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma',
     'Oregon', 'Pennsylvania Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas',
     'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']

  TENANTS = ['7/11', 'Racetrac', 'CVS', 'Walgreens', 'Capital One', 'First Choice Emergency',
             'BBVA', 'PNC', 'Chase', 'Bank of America', 'Bright Horizons', 'MB', 'TD', 'WaWa']

  LEASE_TYPES = ['Ground Lease with Operating Tenant', 'Ground Lease Self Occupancy', 'Space Lease']

  BUILDING_STATUS = ['Operational', 'Not Yet Built', 'Under Construction']

  DATE_OF_LEASE_DETAILS = ['Date is clearly on document', 'Date can be inferred from document',
                           'Date known by letter agreement', 'Date not certain', 'Lease not yet signed']

  RENT_COMMENCEMENT_DATE_DETAILS = ['Date is fixed in document and has not yet occurred',
                                    'Date is fixed in document and has occurred',
                                     'Date set by factors that have no yet occurred',
                                    'Date known by letter agreement',
                                    'Date not certain'
  ]
  
  OWNERSHIP_STATUS = ['Purchased', 'Prospective Purchase']
  
  ABBREVIATIONS = {"Alaska"=>"AK", "Alabama"=>"AL", "Arkansas"=>"AR", 
    "American Samoa"=>"AS", "Arizona"=>"AZ", 
     "California"=>"CA", "Colorado"=>"CO",
     "Connecticut"=>"CT", "District of Columbia"=>"DC", 
     "Delaware"=>"DE", "Florida"=>"FL", "Georgia"=>"GA", 
     "Guam"=>"GU", "Hawaii"=>"HI", "Iowa"=>"IA", "Idaho"=>"ID", 
     "Illinois"=>"IL", "Indiana"=>"IN", "Kansas"=>"KS", 
     "Kentucky"=>"KY", "Louisiana"=>"LA", "Massachusetts"=>"MA", 
     "Maryland"=>"MD", "Maine"=>"ME", "Michigan"=>"MI", 
     "Minnesota"=>"MN", "Missouri"=>"MO", "Mississippi"=>"MS", 
     "Montana"=>"MT", "North Carolina"=>"NC", "North Dakota"=>"ND", 
     "Nebraska"=>"NE", "New Hampshire"=>"NH", "New Jersey"=>"NJ", 
     "New Mexico"=>"NM", "Nevada"=>"NV", "New York"=>"NY", "Ohio"=>"OH", 
     "Oklahoma"=>"OK", "Oregon"=>"OR", "Pennsylvania"=>"PA", 
     "Puerto Rico"=>"PR", "Rhode Island"=>"RI", "South Carolina"=>"SC", 
     "South Dakota"=>"SD", "Tennessee"=>"TN", "Texas"=>"TX", 
     "Utah"=>"UT", "Virginia"=>"VA", "Virgin Islands"=>"VI", 
     "Vermont"=>"VT", "Washington"=>"WA", "Wisconsin"=>"WI", 
     "West Virginia"=>"WV", "Wyoming"=>"WY"} 

  def abbreviations_state
    ABBREVIATIONS[location_state]
  end

  def show_cap_rate
    ("%.2f" % cap_rate.to_f.to_s) + "%" if cap_rate.present?
  end

  def ownership_entity_dropdown
    if ownership_status == "Purchased"
      Client.purchased_entity
    else
      Contact.prospective_entity
    end
  end

  def ownership_person_dropdown
    if ownership_status == "Purchased"
      Client.purchased_person
    else
      Contact.prospective_person
    end
  end

  def owner
    if owner_person_is
      if ownership_status == "Purchased"
        Client.find_by_id(owner_person_id)
      else
        Contact.find_by_id(owner_person_id)
      end
    else
      if ownership_status == "Purchased"
        Entity.find_by_id(owner_entity_id)
      else
        Contact.find_by_id(owner_entity_id)
      end
    end
  end

  # Views
  def city_state
    "#{self.city} #{self.state}"
  end

  def created_at_to_string
    created_at.to_string
  end

  def delete_url
    Rails.application.routes.url_helpers.admin_property_path(self)
  end
  
  def view_address
    "#{location_city}, #{location_state}, #{location_street_address}, #{location_county}"
  end

  def self.resources_url
    Rails.application.routes.url_helpers.admin_properties_path
  end

  def self.view_index_columns
    [
      { show: 'Title', call: 'title' },
      { show: 'Type', call: 'type_is' },
      { show: 'Address', call: 'view_address' },
      { show: 'Created', call: 'created_at_to_string' },
    ]
  end

end
