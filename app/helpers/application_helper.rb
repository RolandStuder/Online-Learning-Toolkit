module ApplicationHelper
  
  def flash_messages
      %w(notice warning error success).each do |msg|
        concat content_tag(:div, content_tag(:p, flash[msg.to_sym]),
          :class => "message #{msg}") unless flash[msg.to_sym].blank?
      end
  end
  
  def sanitize_input
    
  end
  
end
