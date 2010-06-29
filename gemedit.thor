#module: gemedit

class Gemedit < Thor
   
   desc "view NAME", "view gem directory in Gedit"
   def view(name)
   
     term = name + '*'
 
     puts "Searching for '" + term + "'..."
 
     # get the path to the gem directory from rubygems and search for any matching directories
     path = `gem env gemdir`
     new_path = File.join([path.chomp, 'gems'])
     Dir.chdir(new_path)
     @d_arr = Dir.glob(term)
 
     if @d_arr.empty?
       puts "Sorry, nothing like that found"
     elsif @d_arr.size == 1
       view_one()
     else
       view_list()
     end
   end
     
   private
   
     def view_one
       puts @d_arr.first
       print 'Do you want to view this? [Y/n]: '
       resp = STDIN.gets.chomp!
       if resp.empty? or resp.downcase == 'y'
         Dir.chdir(@d_arr.first)
         readme_file = Dir.glob('README*')
         exec "gedit #{readme_file}"
       end
     end
     
     def view_list
       @d_arr.each_with_index {|d,i| puts "#{i + 1}: #{d}"}
       puts
       print 'Choose a directory or quit(q): '
       idx = STDIN.gets.chomp!
       if idx.downcase == 'q'
         exit
       elsif (1..@d_arr.size).include?(idx.to_i)
         Dir.chdir(@d_arr.at(idx.to_i - 1))
         readme_file = Dir.glob('README*')
         exec "gedit #{readme_file}"
       else
         puts 'not a valid option'
       end
     end 
   
end
