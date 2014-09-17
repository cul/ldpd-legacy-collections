require 'json'
require 'nokogiri'
def load_objects(dir)
  objects = []
  open(File.join(dir, 'object-manifest.txt')) do |blob|
    blob.each do |line|
      line.strip!
      objects << line
    end
  end
  objects = objects.collect do |obj_path|
    obj = open(File.join(dir,obj_path)) {|f| JSON.load(f)}
    obj['descMetadata'] = File.join(dir,obj['descMetadata'])
    if obj['structMetadata']
      obj['structMetadata'] = File.join(dir,obj['structMetadata'])
    end
    obj['members'].each do |member|
      member['descMetadata'] = File.join(dir,member['descMetadata'])
    end
    obj
  end
end

objects = load_objects('.')
puts "loaded #{objects.length} objects"
ferriss = 1 #BagAggregator.search_repo(identifier: 'ldpd.ferriss').first
raise "no ferriss BagAggregator" unless ferriss
ggva = 1 #BagAggregator.search_repo(identifier: 'ldpd.ggva').first
raise "no ggva BagAggregator" unless ggva
objects.each do |object|
  ng_xml = open(object["descMetadata"]) { |f| Nokogiri::XML(f) }
  title = ng_xml.xpath('/mods:mods/mods:titleInfo/mods:title', mods:"http://www.loc.gov/mods/v3").first.text
  puts title
  object['members'].each do |member|
    ng_xml = open(member["descMetadata"]) { |f| Nokogiri::XML(f) }
    title = ng_xml.xpath('/mods:mods/mods:titleInfo/mods:title', mods:"http://www.loc.gov/mods/v3").first.text
    puts "-- #{title}"
  end    
end
    