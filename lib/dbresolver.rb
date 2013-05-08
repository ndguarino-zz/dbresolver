require "singleton"

module DBResolver
  class Resolver < ActionView::Resolver
    include Singleton

    def find_templates(name, prefix, partial, details)
      return [] if @@options[:prefix] && !@@options[:prefix].include?(prefix)

      conditions = {}
      conditions[(details[:name] || "name").to_sym] = (details[:use_prefix] || @@options[:use_prefix]) ? build_path(name, prefix) : name
      if details[:conditions]
        conditions.merge! details[:conditions]
      end
      
      klass = details[:model] || @@options[:model] || prefix
      if klass.is_a? String
        klass = klass.camelize.constantize rescue nil
      end
      return [] if klass.nil?

      return [] unless klass.respond_to? :where  # Ensure we can look up the thing
                                               # Yes, thing. Because that's a
                                               # technical term.

      res = klass.where(conditions)
      return [] if res.empty?

      res.map do |record|
        initialize_template(record, name, prefix, partial, details)
      end
    end

    def self.using(options = {})
      @@options = options
      self.instance
    end

    private
    def initialize_template(record, name, prefix, partial, details)
      source = ""
      if @@options[:body_name] and record.respond_to? @@options[:body_name].to_sym
        source = record.call(@@options[:body_name].to_sym)
      elsif details[:body_name] and record.respond_to? details[:body_name].to_sym
        source = record.call(details[:body_name].to_sym)
      elsif record.respond_to? :body
        source = record.body
      elsif record.respond_to? :content
        source = record.content
      end

      identifier = "#{record.class}::#{name}(#{record.id})"

      if record.respond_to? :handler
        handler = ActionView::Template.registered_template_handler(record.handler)
      elsif details[:handlers] and details[:handlers].first.present?
        handler = ActionView::Template.registered_template_handler(details[:handlers].first)
      else
        handler = ActionView::Template.registered_template_handler("erb")
      end

      m_details = {}

      m_details[:format] = Mime[record.respond_to?(:format) ? record.format : (details[:format] || "text/html")]
      m_details[:updated_at] = record.respond_to?(:updated_at) ? record.updated_at : nil
      path = build_path(name,prefix)
      m_details[:virtual_path] = virtual_path(record.respond_to?(:path) ? record.path : path, record.respond_to?(:partial) ? record.partial : partial)

      m_details.merge! details

      ActionView::Template.new(source, identifier, handler, details)
    end

    def virtual_path(path, partial)
      return path unless partial
      if index=path.rindex("/")
        path.insert(index+1,"_")
      else
        "_#{path}"
      end
    end

    def build_path(name, prefix,partial=false)
      path = prefix.present? ? "#{prefix}/#{name}" : name
      path unless partial
      virtual_path(path,partial)
    end
  end
end
