module LanguageTool
  class Process
    FLAGS = %w(api auto_detect_language apply break_as_paragraph_break
               bilingual encoding disable enable language mothertongue
               recursive taggeronly list_unknown profile verbose)

    DEFAULT_ARGS = FLAGS.inject({}) do |h, flag|
      h[flag.to_sym] = true
      h
    end
    DEFAULT_ARGS[:api] = true
    DEFAULT_ARGS[:enable] = []
    DEFAULT_ARGS[:disable] = []
    DEFAULT_ARGS[:language] = "en"

    attr_accessor :path,
                  :opts

    def initialize(path = LanguageTool::Jars.location, opts = {})
      self.path = path
      self.opts = opts
      @started = false
      @closing = false
    end

    def start!
      @started = true
      Dir.chdir(self.path) do
        @process = IO.popen("java -jar languagetool-commandline.jar --api -l en-GB -m de-DE -b -", "r+")
      end
    end

    def shutdown!
      @closing = true
      @started = false
      @process.close_write
      @process.read
      @process.close
      @closing = false
      $?
    end

    def feed(text)
      text << "\n" if text[-1,1] != "\n"
      buf = ""
      @process.write(text)
      while line = @process.readline do
        buf << line
        break if line == "</matches>\n"
      end
      buf
    end
  end
end