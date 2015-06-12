require "action_view"

def view
  @view ||= create_view
end

def create_view
  template_path = File.expand_path("../web-console/lib/web_console/templates", __FILE__)
  context = ActionView::LookupContext.new(template_path)
  context.cache = false
  ActionView::Base.new(context)
end

def render(template)
  ""
end

def render_inlined_string(template)
  view.render template: template, layout: 'layouts/inlined_string'
end

def only_on_error_page(&block)
  if defined?(WITHOUT_ERROR_PAGE)
    yield
  end
end

@session = Class.new do
  def id
    "fake-session-id"
  end
end.new
