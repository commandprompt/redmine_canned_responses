module RedmineCannedResponses
  module ProjectPatch
    unloadable

    def self.included(base)
      base.class_eval do
        has_many :canned_responses, lambda { order('title') }
      end
    end
  end
end
