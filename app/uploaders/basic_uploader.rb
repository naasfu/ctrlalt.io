class BasicUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end

  version :sm do
    process resize_to_fit: [350, 350]
  end

  version :sm_square do
    process resize_to_fill: [350, 350]
  end

  version :md do
    process resize_to_fit: [700, 700]
  end

  version :lg do
    process resize_to_fit: [1400, 1400]
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
