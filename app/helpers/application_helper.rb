module ApplicationHelper
  # def sidebar_link(icon_class, text, route = "#", options = {})
  #   content_tag(:div) do
  #       concat(link_to(route, options, class: "text-decoration-none d-flex gap-2 align-items-center my-4") do
  #           concat(content_tag(:i, '', class: "fa-solid #{icon_class}", style: 'color: #5e6278;'))
  #           concat(content_tag(:p, text, class: 'm-0'))
  #       end)
  #   end
  # end

  def sidebar_link(icon_class, text, route = "#")
    content_tag(:div) do
        concat(link_to(route, class: "text-decoration-none d-flex gap-3 align-items-center my-1 align-items-center menu-item #{'active' if current_page?(route)}") do
            concat(content_tag(:i, '', class: "fa-solid #{icon_class}", style: 'color: #B973FF;'))
            concat(content_tag(:p, text, class: 'm-0'))
        end)
    end
  end


  def profile_menu_item(text:, icon_class:)
      content_tag(:div, class: 'd-flex gap-2 align-items-center') do
        concat(content_tag(:p, text))
        concat(content_tag(:i, '', class: "fa-regular #{icon_class}", style: 'color: #5e6278;'))
      end
  end
end
