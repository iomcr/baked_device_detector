require "baked_file_system"

class DeviceDetectorFileStorage
  extend BakedFileSystem

  bake_folder "./regexes"
  # bake_folder "./regexes/**/*.yml" # DNE
end

module DeviceDetector
  struct Storage
    @@container = {} of String => String
    @@ready_to_use = false

    FILE_ROOT    = Path[__FILE__].expand.dirname
    REGEXES_PATH = File.join(FILE_ROOT, "regexes", "**/*.yml")

    # def self.setup_regexes
    #   Dir.glob(REGEXES_PATH).each do |path|
    #     name = File.basename(path)
    #     @@container[name] = File.read(path)
    #   end
    #   @@ready_to_use = true
    # end

    def self.get(file_name : String)
      unless @@container[file_name]?
        begin
          file = DeviceDetectorFileStorage.get(file_name)
        rescue ex : BakedFileSystem::NoSuchFileError
          # pass
        end
        unless file
          begin
            file = DeviceDetectorFileStorage.get(File.join("client", file_name))
          rescue ex : BakedFileSystem::NoSuchFileError
            # pass
          end
        end
        unless file
          file = DeviceDetectorFileStorage.get(File.join("device", file_name))
        end
        @@container[file_name] = file.gets_to_end
        # p "@@container[file_name]"
        # p @@container[file_name]
      end
      @@container[file_name]
    end
  end
end
