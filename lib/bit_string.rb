module ActsAsBitString
  
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end
  
  module ClassMethods
    def acts_as_bit_string(options)
      send :include, ActsAsBitString::InstanceMethods
      
      options[:field] ||= :properties
      options[:properties] ||= "@@properties"
      
      self.class_eval <<-EOF
        def #{options[:field]}; self.bit_string_field({:field=>"#{options[:field]}", :properties=>#{options[:properties]}}); end;
        def #{options[:field]}=(value); self.bit_string_field={:field=>"#{options[:field]}", :properties=>#{options[:properties]}, :value=>value}; end;
        def #{options[:field]}_values; #{options[:properties]}; end;
      EOF
    end
  end
  
  module InstanceMethods
    def to_bit_string(properties, properties_array)
      return properties_array.collect{|p| properties.include?(p.to_s) ? "1" : "0"}.join('').reverse
    end

    def from_bit_string(bit_string, properties_array)
      properties = []
      bit_string = bit_string.to_s(2) if bit_string.is_a?(Integer)
      bit_string ||= ""
      bit_string.split('').reverse.each_with_index do |char, index|
        properties << properties_array[index] if char == '1'
      end
      return properties
    end
    
    def bit_string_field(options)
      return self.from_bit_string(self[options[:field].to_s], options[:properties])
    end
    
    def bit_string_field=(options)
      self[options[:field].to_s] = self.to_bit_string(options[:value], options[:properties])
    end
  end
end

ActiveRecord::Base.send :include, ActsAsBitString