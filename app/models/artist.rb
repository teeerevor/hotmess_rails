class Artist < ActiveRecord::Base
  has_many :songs

  def the_name_fix
    return self.name.split(/, /).reverse.join(' ') if self.name =~ /, the/i
    self.name
  end

  def name_plused
    the_name_fix.strip.gsub(/\s+/, '+')
  end

  def short_desc
    if desc && desc.size > 400
      return desc[0..400].to_s + '...'
    end
    desc
  end

  def content_link
    "http://www.last.fm/music/#{name_plused}"
  end
end
