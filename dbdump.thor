#module: dbdump

class Dbdump < Thor::Group
  
  class_option :environment, :default => :development
  desc "Take a database backup of your application"
   
  def backup
    
    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    base_path = `pwd`.chomp
    backup_base = File.join(base_path, 'db/backup')
    if File.exists?(backup_base)
      puts "Directory #{backup_base} already exists"
    else
      puts "Directory #{backup_base} doesn't exist, so we're creating one....."
      Dir.mkdir backup_base
    end
     
    backup_folder = File.join(backup_base, datestamp)
    Dir.mkdir backup_folder
    Dir.chdir "db/backup/#{datestamp}"
    backup_file = File.join(backup_folder, "#{options[:environment]}_dump.sql")    
    db_config = YAML::load(File.open(File.join(base_path,"config/database.yml")))
    db_config = db_config["#{options[:environment]}"]
    username = db_config["username"]    
    password = db_config["password"]
    database = db_config["database"]
    if db_config['adapter'] == 'mysql'
      host = db_config["host"]
      `mysqldump -h #{host} -u #{username} -p#{password} #{database} > #{backup_file}`
    else
      `pg_dump -U #{username} -f #{backup_file} #{database}`
    end
    puts "Created backup: #{backup_file}"
    
  end
  
end

