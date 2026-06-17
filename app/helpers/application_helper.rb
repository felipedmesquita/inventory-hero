module ApplicationHelper
  def nav_link_to(name, path)
    active = current_page?(path) || request.path.start_with?("#{path}/")
    classes = [
      "px-3 py-2 text-sm font-medium border-b-2",
      active ? "border-blue-600 text-blue-700" : "border-transparent text-slate-600 hover:text-slate-950"
    ]

    link_to name, path, class: classes.join(" ")
  end

  def status_badge(record)
    content_tag(:span, record.status.humanize, class: "inline-flex rounded-full bg-slate-100 px-2 py-1 text-xs font-medium text-slate-700")
  end
end
