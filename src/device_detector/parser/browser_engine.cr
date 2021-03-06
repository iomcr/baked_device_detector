module DeviceDetector::Parser
  struct BrowserEngine
    getter kind = "browser_engine"
    @@engines = Array(Engine).from_yaml(Storage.get("browser_engine.yml"))

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct Engine
      include YAML::Serializable

      property regex : String
      property name : String
    end

    def engines
      return @@engines if @@engines
      @@engines = Array(Engine).from_yaml(Storage.get("browser_engine.yml"))
    end

    def call
      detected_engine = {"name" => ""}
      engines.reverse_each do |engine|
        if Regex.new(engine.regex, Setting::REGEX_OPTS) =~ @user_agent
          detected_engine.merge!({"name" => engine.name})
        end
      end
      detected_engine
    end
  end
end
