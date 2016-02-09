require 'kintone/command'

class Kintone::Command::File < Kintone::Command
  def self.path
    'file'
  end

  def get(file_key)
    @api.get(@url, fileKey: file_key)
  end

  def register(path, content_type, original_filename)
    @api.post_file(@url, path, content_type, original_filename)
  end
end
