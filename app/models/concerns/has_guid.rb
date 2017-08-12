module HasGuid
  extend ActiveSupport::Concern

  included do
    before_create :populate_guid
  end

  def to_param
    guid
  end

private

  def populate_guid
    self.guid = SecureRandom.hex(4).upcase
  end
end