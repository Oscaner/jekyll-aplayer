# frozen_string_literal: true

module Jekyll::Aplayer
  class Netease < Processor

    def process?
      return true if Type.html?(output_ext) or Type.markdown?(output_ext)
    end

  end
end
