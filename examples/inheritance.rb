$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'


if $0 == __FILE__
  puts balbo('inheritance', {'title'=>"My Page"}, File.dirname(__FILE__))
end

__END__
<html>
  <head>
  <title>My Page</title>
  </head>
  <body>
    <h1>Home</h1>
    <p>This is my page</p>
</body>
</html>
