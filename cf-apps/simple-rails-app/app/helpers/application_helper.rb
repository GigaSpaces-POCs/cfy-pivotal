module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = "Cloudify :: CloudFoundry APP"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("cloudify-logo.png", :alt => "Cloudify :: CloudFoundry APP", :class => "round")
  end
end
