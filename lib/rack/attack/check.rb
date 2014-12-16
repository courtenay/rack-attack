unless Hash.respond_to?(:fetch)
  class Hash
    def fetch(key, default=nil)
      self[key] || default
    end
  end
end

module Rack
  class Attack
    class Check
      attr_reader :name, :block, :type
      def initialize(name, options = {}, &block)
        @name, @block = name, block
        @type = options.fetch(:type, nil) if options.is_a?(Hash)
      end

      def [](req)
        block[req].tap {|match|
          if match
            req.env["rack.attack.matched"] = name
            req.env["rack.attack.match_type"] = type
            Rack::Attack.instrument(req)
          end
        }
      end

    end
  end
end

