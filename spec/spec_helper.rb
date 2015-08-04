require 'serverspec'

if ENV['CIRCLECI']
  require 'coveralls'
  require 'yarjuf'

  Coveralls.wear!
end

