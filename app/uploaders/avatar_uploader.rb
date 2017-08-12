class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def default_url
    ActionController::Base.helpers.asset_path("defaults/avatars/" + [version_name, "default.jpg"].compact.join('_'))
  end

  version :sm do
    process resize_to_fill: [75, 75]
  end

  version :md do
    process resize_to_fill: [150, 150]
  end

  version :lg do
    process resize_to_fill: [300, 300]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if original_filename
      name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{name}.#{file.extension}"
    end
  end
end
