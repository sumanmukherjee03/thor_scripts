#module: installgem

class Installgem < Thor
  desc "geminstall NAME", "install the gems mentioned in the file one by one"
  
  def geminstall(name)
    global_install_commands = []
    file = File.open(name)
    gems = file.readlines.collect{|line| line.strip!}
    gems.each do |gem|
      x = gem.split(/ /,2)
      gem_name = x[0]
      versions = x[1][1...-1].split(/,/).each{|v| v.strip!}
      gem_install_commands = []
      versions.each {|version| gem_install_commands << "gem install #{gem_name} -v #{version}"}
      global_install_commands << gem_install_commands
    end
    
    global_install_commands.flatten!
    
    gem_sources = ["http://gems.github.com","http://gemcutter.org"]
    gem_sources.each{|source| (system "gem sources -a #{source}") ? "Successfully added #{source} to gem source" : "Failed to add #{source} to gem sources"}
    
    
    loop {
      atleast_one_installed = false
      global_install_commands.each do |command|
        system "echo #{command}"
        output = system "#{command}"
        if output
          global_install_commands.delete(command)
          atleast_one_installed = true
          system "echo *************Successfully installed**************"
        else
          system "echo *************Failed to install**************"
        end
      end
      
      if !global_install_commands.empty? && atleast_one_installed
        system "echo **********************Trying again*********************"
        redo
      elsif !global_install_commands.empty? && !atleast_one_installed
        system "echo *************Some gems could not be installed. Try installing them manually***************"
        break
      elsif global_install_commands.empty?
        system "echo *************All gems successfully installed***************"
        break
      end
      
    }  
    
  end
end
