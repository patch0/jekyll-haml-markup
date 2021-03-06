$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'jekyll-haml-markup'

require 'minitest/autorun'

def root_dir(*subdirs)
  File.expand_path(File.join('..', *subdirs), __dir__)
end

def test_dir(*subdirs)
  root_dir('test', *subdirs)
end

def source_dir(*subdirs)
  test_dir('fixtures', *subdirs)
end

def dest_dir(*subdirs)
  test_dir('.tmp', *subdirs)
end

def default_configuration
  Marshal.load(Marshal.dump(Jekyll::Configuration::DEFAULTS))
end

def build_configs(overrides, base_hash = default_configuration)
  Jekyll::Utils.deep_merge_hashes(base_hash, overrides)
end

def site_configuration(overrides = {})
  configs = build_configs 'destination' => dest_dir, 'incremental' => false
  build_configs overrides, configs
end

def fixture_site(overrides = {})
  Jekyll::Site.new(site_configuration(overrides))
end

def xslt
  Nokogiri::XSLT <<-XSL
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
      <xsl:copy-of select=".">
    </xsl:template>
  </xsl:stylesheet>
  XSL
end
