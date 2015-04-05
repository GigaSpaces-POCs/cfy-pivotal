namespace :colorful do

  desc 'Reset the color of certain content on the homepage'
  task :restyle, [:color] do |task, args|
    val = args['color']
    tmpfile = temp_file('custom')

    command =
        'sed -e "s:black; \\/\* hi, mom \\*\\/:REPLACE;:" ./public/stylesheets/custom.css > TMPFILE'
        .gsub('REPLACE', val)
        .gsub('TMPFILE', tmpfile)
    do_exec command

    command =
        'mv -f /tmp/custom.* ./public/stylesheets/custom.css'
    do_exec command

  end

  desc 'Reset the certain content on the homepage'
  task :update_content, [:color] do |task, args|
    val = args['color']
    tmpfile = temp_file('home')

    command =
        'sed -e "s:HIMOM:REPLACE:" ./app/views/pages/home.html.erb > TMPFILE'
        .gsub('REPLACE', val)
        .gsub('TMPFILE', tmpfile)
    do_exec command

    command =
        'mv -f /tmp/home.* ./app/views/pages/home.html.erb'
    do_exec command

  end

  def do_exec(the_command)
    puts the_command
    system the_command
  end

  # @param [string] piece
  # @return /tmp/piece.[some random string]
  def temp_file( piece )
    tmpfile = '/tmp/FILENAME.EXT'
      .gsub('FILENAME', piece)
      .gsub('EXT', random_string)
    # puts 'temp file name', tmpfile
    command = 'touch FILE'.gsub('FILE', tmpfile)
    do_exec command
    tmpfile
  end

  def random_string
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    string = (0...24).map { o[rand(o.length)] }.join
    string
  end

end