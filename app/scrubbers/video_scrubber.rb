# This scrubber is analog of :prune build-in scrubber
#  (http://rubydoc.info/github/flavorjones/loofah/master/Loofah/Scrubbers/Prune)
# with allowed @tags and @attributes lists.
# Fallback to default :strip behavior included.

class VideoScrubber < Loofah::Scrubber

  PATTERNS_VIDEO = [
      /(www\.)?youtube\.com\//i,
      /instagram\.com/i,
      /vine\.co/i,
      /(player\.)?vimeo\.com\//i,
      /.+dailymotion.com\//i,
      /\/\/v\.youku\.com/i,
      /^.+.(mp4|m4v)$/i,
      /^.+.(ogg|ogv)$/i,
      /^.+.(webm)$/i
  ]

  REGEX_VIDEO = Regexp.union(PATTERNS_VIDEO)

  def initialize(options={})
    @direction = :top_down
    @tags = options[:tags]
    @attributes = options[:attributes]
  end

  def scrub(node)
    return CONTINUE if html5lib_sanitize(node) == CONTINUE

    # case for iframe
    if (node.name == 'iframe')
      if(REGEX_VIDEO.match(node.attribute('src')))
        return CONTINUE
      end
    end
    node.remove
    return STOP
  end


end