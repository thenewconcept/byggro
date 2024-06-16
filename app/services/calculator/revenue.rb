module Calculator
  class Revenue
    def initialize(resource)
      @resource = resource
    end

    def amount
      if @resource.is_a?(Project)
        @resource.checklists.sum(&:revenue)
      else
        @resource.revenue
      end
    end

    def other
      if @resource.is_a?(Project)
        @resource.misc_amount
      else
        0
      end
    end

    def material
      if @resource.is_a?(Project)
        @resource.material_amount
      else
        0
      end
    end

    def total
      if @resource.is_a?(Enumerable)
        @resource.reduce(0) { |sum, resource| sum + Revenue.new(resource).total }
      else
        amount + material + other
      end
    end
  end
end