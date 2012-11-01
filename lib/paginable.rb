#coding: UTF-8
module Paginable
 module Controller
  def self.included(base)
   base.instance_eval do
    helper_method :paginate
   end
  end

  def paginate(parm = {})
   if parm.has_key?(:derid) && parm[:derid].is_a?(Hash)

   else
    options = {:show_numbers => true, :show_prevnext => false, :show_firstlast => false}.merge(defined?(opts) ? opts : {})
    content_for :text_before_current do
     if options[:text_before_current]
      render options[:text_before_current]
     end
    end
    content_for :text_after_current do
     if options[:text_after_current]
      render options[:text_after_current]
     end
    end
    m_col = ((page - 2 > 1 ? page - 2 : 1)..(page + 2 < pages ? page + 2 : pages)).to_a
    f_col = [pages > 1 ? 1 : nil].compact - m_col
    e_col = [pages > 1 ? pages : nil].compact - m_col
    render .pagination do
     if options[:text_before]
      render options[:text_before]
     end
     if options[:show_firstlast]
      unless page <= 1
       render link_to "<<", url_for(params.merge(:page => '1'))
      end
     end
     if options[:show_prevnext]
      unless page <= 2
       render link_to "<", url_for(params.merge(:page => (page - 1).to_s))
      end
     end
     if options[:show_numbers]
      unless pages <= 1
       f_col.each do |i|
        if i == page
         render content_for :text_before_current
         render %span.current= i.to_s
         render content_for :text_after_current
      
        else
         render link_to i.to_s, url_for(params.merge(:page => i.to_s))
        end
       end
       m_col.each do |i|
        if i == page
         render content_for :text_before_current
         render %span.current= i.to_s
         render content_for :text_after_current
        else
         render link_to i.to_s, url_for(params.merge(:page => i.to_s))
        end
       end
       e_col.each do |i|
        if i == page
         render content_for :text_before_current
         render %span.current= i.to_s
         render content_for :text_after_current
        else
         render link_to i.to_s, url_for(params.merge(:page => i.to_s))
        end
       end
      end
     else
      if options[:show_current]
       render content_for :text_before_current
       render %span.current= page.to_s
       render content_for :text_after_current
      end
     end
     if options[:show_prevnext]
      unless page >= pages - 1
       render link_to ">", url_for(params.merge(:page => (page + 1).to_s))
      end
     end
     if options[:show_firstlast]
      unless page >= pages
       render link_to ">>", url_for(params.merge(:page => pages.to_s))
      end
     end
     if options[:text_after]
      render options[:text_after]
     end
    end
   end
  end
 end

end
