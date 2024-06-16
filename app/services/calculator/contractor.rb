module Calculator
  class Contractor
    def initialize(resource)
      @resource = resource
    end

    def total
      @resource.reports.by_reportees('Contractor').payable.sum(&:total)
    end
  end
end