namespace :colorful do

  desc "Reset the color of certain content on the homepage"
  task :restyle, [:color] do | t, args |
    val = args['color']
    puts 'color is: ', val
    command =
        'sed -i "~" "s:black; \\/\* hi, mom \\*\\/:REPLACE;:" ./public/stylesheets/custom.css'
        .gsub('REPLACE', val)
    puts 'command is: ', command
    system command
  end

  desc "Reset the certain content on the homepage"
  task :update_content, [:color] do | t, args |
    val = args['color']
    puts 'color is: ', val
    command =
        'sed -i "~" "s:HIMOM:REPLACE:" ./app/views/pages/home.html.erb'
        .gsub('REPLACE', val)
    puts 'command is: ', command
    system command
  end

end