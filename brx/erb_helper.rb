require "pathname"

def root(path = "")
  Pathname(File.expand_path "../../", __FILE__).join(path).to_s
end

require "action_view"
require "action_dispatch"
require "web_console"

def view
  @__view ||= create_view
end

def create_view
  view_path = root("lib/web_console/templates")
  context = ActionView::LookupContext.new(view_path)
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
