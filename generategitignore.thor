#module: generategitignore

class Generategitignore < Thor::Group
  include Thor::Actions

  def self.source_root
    File.dirname(__FILE__)
  end
  
  def create_gitignore_file
    template('/home/suman/My_tryouts/independent ruby scripts/templates/gitignore.tt', ".gitignore")
  end
  
end
