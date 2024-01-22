require "json"
require "json-schema"
require "net/http"
require "yaml"

# Register draft-07 used by DD schemas
class Draft07 < JSON::Schema::Draft4
  def initialize
    super

    @uri = JSON::Util::URI.parse("http://json-schema.org/draft-07/schema#")
    @names = ["http://json-schema.org/draft-07/schema#"]
  end

  JSON::Validator.register_validator(new)
end

module DDValidate
  class FetchDDSchema
    def self.call(version)
      uri = URI("https://raw.githubusercontent.com/DataDog/schema/main/service-catalog/#{version}/schema.json")
      res = Net::HTTP.get_response(uri)

      unless res.is_a?(Net::HTTPSuccess)
        warn "Unable to fetch DataDog schema for service-catalog"
        warn "URI: #{uri}"
        warn "Response: #{res}"
        warn "Your schema-version may be invalid"
        exit 1
      end

      res.body
    end
  end

  class DDService
    def self.load(path, schema_fetcher = FetchDDSchema)
      YAML.load_stream(File.read(path)).map do |definition|
        new(definition, schema_fetcher)
      end
    end

    attr_reader :name, :errors

    def initialize(definition, schema_fetcher)
      schema_version = definition.fetch("schema-version")
      schema = schema_fetcher.call(schema_version)

      @name = definition["dd-service"] || "unknown"
      @errors = JSON::Validator.fully_validate(schema, definition)
    end

    private_class_method :new
  end
end
