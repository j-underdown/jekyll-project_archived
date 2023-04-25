module Jekyll
  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_page.html')
      self.data['tag'] = tag
      self.data['title'] = "Tag: #{tag}"
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag_page'
        dir = 'tag'
        tags = []

        if site.collections.key?('posts')
          collection = site.collections['posts']
          collection_tags = collection.docs.flat_map { |d| d.data['tags'] || [] }.uniq
          collection_tags.each do |tag|
            if !tag.nil? && !tag.empty?
              tags << tag
            end
          end
        end

        tags = tags.uniq

        tags.each do |tag|
          if !tag.empty? && !tag.nil?
            site.pages << TagPage.new(site, site.source, File.join(dir, tag.downcase.tr(" ", "-")), tag)
          end
        end
      end
    end
  end
end
