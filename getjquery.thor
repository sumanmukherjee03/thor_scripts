#module: getjquery

class Getjquery < Thor::Group
  
  argument :version, :type => :string, :default => "1.4.2.min", :desc => "The version to download like 1.4.2.min"
  
  desc "Getting Jquery....please wait"
  def getjs
    `curl -L http://code.jquery.com/jquery-#{version}.js > public/javascripts/jquery-#{version}.js`
  end
  
end
