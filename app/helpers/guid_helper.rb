module GuidHelper
  def short_guid(obj)
    "#{obj.class.name[0..2]}##{obj.guid.split('-')[0]}".upcase
  end
end
