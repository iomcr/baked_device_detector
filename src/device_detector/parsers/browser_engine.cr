module DeviceDetector
  class BrowserEngineStore
    getter kind = "browser_engine"

    def initialize(user_agent : String)
      @engines = Array(Engine).from_yaml(Storage.get("browser_engine.yml").gets_to_end)
      @user_agent = user_agent
    end

    class Engine
      YAML.mapping(
        regex: String,
        name: String
      )
    end

    def call
      detected_engine = {} of String => String
      @engines.reverse_each do |engine|
        if Regex.new(engine.regex, Regex::Options::IGNORE_CASE) =~ @user_agent
          detected_engine.merge!({"name" => engine.name})
        end
      end
      detected_engine
    end
  end
end
