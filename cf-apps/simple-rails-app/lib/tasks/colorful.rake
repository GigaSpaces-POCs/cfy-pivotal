namespace :colorful do


  desc "Reset the color of certain content on the homepage"
  task :restyle, [:color] do | t, args |
    val = args['color']
    command = "sed -i \"s*#{'black; /\* hi, mom \*/'}*#{'FILLMEIN;'}*\" ./public/stylesheets/custom.css ".gsub('FILLMEIN', val)
    puts command
    # system `command`
  end

  desc "Reset the certain content on the homepage"
  task :update_content do

  end

  def is_hex(css_color)
    if css_color.nil?
      return false
    end
    first_char = css_color[0..1]
    first_char.equal?('#') unless first_char.nil?
  end

end