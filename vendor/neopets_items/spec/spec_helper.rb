$:.unshift File.expand_path('..', __FILE__)

FIXTURE_BASE = Pathname.new(File.expand_path('../../fixtures', __FILE__))
def fixture_html(filename)
  File.read(FIXTURE_BASE.join(filename))
end

