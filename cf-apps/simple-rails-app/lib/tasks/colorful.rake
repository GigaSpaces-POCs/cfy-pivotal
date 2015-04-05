namespace :colorful do

  desc "Reset the color of certain content on the homepage"
  task :restyle, [:color] do |t, args|
    val = args['color']
    tmpfile = temp_file

    command =
        'sed -i "~" "s:black; \\/\* hi, mom \\*\\/:REPLACE;:" ./public/stylesheets/custom.css'
        .gsub('REPLACE', val)
        .gsub('TMPFILE', tmpfile)
    do_exec command

    command =
        'mv -f TMPFILE ./public/stylesheets/custom.css'
    do_exec command

  end

  desc "Reset the certain content on the homepage"
  task :update_content, [:color] do |t, args|
    val = args['color']
    tmpfile = temp_file
    puts 'XXXXXXXX', tmpfile

    command =
        'sed -e "s:HIMOM:REPLACE:" ./app/views/pages/home.html.erb > TMPFILE'
        .gsub('REPLACE', val)
        .gsub('TMPFILE', tmpfile)
    do_exec command

    command =
        'mv -f TMPFILE ./app/views/pages/home.html.erb'
        .gsub('TMPFILE', tmpfile)
    do_exec command

  end

  def do_exec(the_command)
    puts 'command is: ', the_command
    system the_command
  end

  def temp_file
    tmpfile = '/tmp/FILENAME'.gsub('FILENAME', random_string)
    # puts 'temp file name', tmpfile
    command = 'mktemp FILE'.gsub('FILE', tmpfile)
    do_exec command
    tmpfile
  end

  def random_string
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    string = (0...24).map { o[rand(o.length)] }.join
    string
  end

end