#module: generategitignore

class Generategitignore < Thor::Group
  include Thor::Actions

  def self.source_root
    File.dirname(__FILE__)
  end
  
  def create_gitignore_file
    template("#{Generategitignore.source_root}/../Templates/gitignore.tt", ".gitignore")
  end
  
end
