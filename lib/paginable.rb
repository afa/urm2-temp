#coding: UTF-8
module Paginable
 module Controller
  def self.included(base)
   base.instance_eval do
    helper_method :paginate
   end
  end
   # #29220
  def paginate(parm = {})
   if parm.has_key?(:derid) && parm[:derid].is_a?(Hash)
    options = parm[:derid]
    page = parm[:page].to_i
    pages = parm[:pages].to_i
    page = 1 if page < 1
    pages = 1 if pages < 1
    page = pages if page > pages
    return render_to_string(:nothing => true) if options[:hide_empty] && pages == 1
    prt = case pages
     when 1..11 then "shared/page_1_11.html.haml"
     when 12 then page > 6 ? "shared/page_12_7.html.haml" : "shared/page_12_6.html.haml"
     when 12..1000000 then page > (pages - 6) ? "shared/page_13_last.html.haml"  : (page.between?(7, pages - 6) ? "shared/page_13_mid.html.haml" : "shared/page_13_first.html.haml")
    end
    render_to_string(:partial => prt, :locals => {:page => page, :pages => pages, :opts => parm[:derid], :parms => params}).html_safe
=begin
    options = {:outer_window => 1, :inner_window => 3, :undotted_count => 1, :page => 1, :pages => 0, :hide_empty => true}.merge(parm[:derid])
    m_col = ((page - options[:inner_window] > 1 ? page - options[:inner_window] : 1)..(page + options[:inner_window] < pages ? page + options[:inner_window] : pages)).to_a
    f_col = [pages > 1 ? 1 : nil].compact - m_col
    e_col = [pages > 1 ? pages : nil].compact - m_col
    fm_col = ((f_col.last || 1)..(m_col.first || 1)).to_a - f_col - m_col
    me_col = ((m_col.last || pages)..(e_col.first || pages)).to_a - e_col - m_col
    render_to_string(:text => "<div class=\"pagination\" #{options.has_key?(:align) ? "style=\"text-align: #{options[:align]};\"" : ''}>#{f_col.empty? ? "" : f_col.map{|i| "<a href=\"#{url_for(params.merge(:page => i))}\">#{i}</a>"}.join }#{fm_col.size > options[:undotted_count] ? '...' : fm_col.map{|i| "<a href=\"#{ url_for(params.merge(:page => i))}\">#{i}</a>"}.join}#{m_col.map{|i| i.to_i == page ? "<span class=\"current\">#{i}</span>" : "<a href=\"#{ url_for(params.merge(:page => i))}\">#{i}</a>" }.join}#{me_col.size > options[:undotted_count] ? '...' : me_col.map{|i| "<a href=\"#{ url_for(params.merge(:page => i))}\">#{i}</a>"}.join}#{e_col.empty? ? "" : e_col.map{|i| "<a href=\"#{url_for(params.merge(:page => i))}\">#{i}</a>"}.join }</div>").html_safe
=end
   else
    render_to_string :nothing => true
=begin    options = {:show_numbers => true, :show_prevnext => false, :show_firstlast => false}.merge(defined?(opts) ? opts : {})
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
=end
   end
  end
 end

end
