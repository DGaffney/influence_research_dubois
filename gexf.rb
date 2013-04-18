class GEXF
  attr_accessor :file
  def initialize(file)
    @file = file
  end
  
  def write(content)
    content = content.gsub("&", "&amp;")
    @file.write(content)
  end
  
  def write_all(opts={})
    header_declaration
    graph_declare = opts[:graph_declaration] || {}
    graph_declaration(graph_declare)
    attribute_declarations(opts[:attributes])
    nodes(opts[:nodes])
    edges(opts[:edges])
    footer
    @file
  end
  
  def header_declaration
    write(%{<gexf xmlns="http://www.gexf.net/1.1draft" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.1draft http://www.gexf.net/1.1draft/gexf.xsd" version="1.1">\n})
  end
  
  def graph_declaration(opts={})
    opts[:mode] ||= "static"
    opts[:time_format] ||= "double"
    opts[:default_edge_type] ||= "directed"
    write(%{\t<graph mode="#{opts[:mode]}" timeformat="#{opts[:time_format]}" defaultedgetype="#{opts[:default_edge_type]}">\n})
  end
  
  #looks like {:node => {:static => [{:id => "statuses_count", :title => "Statuses Count", :type => "double"}]}}
  def attribute_declarations(attributes={})
    attribute_declaration = %{}
    attributes.keys.each do |type|
      attributes[type].each_pair do |mode, attributes|
        attribute_declaration += %{\t\t<attributes class="#{type}" mode="#{mode}">\n}
        attributes.each do |attribute|
          attribute_declaration += %{\t\t\t<attribute }
          attribute.each_pair do |key, value|
            attribute_declaration += %{#{key}="#{value}" }
          end
          attribute_declaration += %{/>\n}
        end
        attribute_declaration += %{\t\t</attributes>\n}
      end
    end
    write(attribute_declaration)
  end
  
  #attributes look like [{:for => "attribute_name", :value => 1, :start => Time.now-24*60*60*7, :end => Time.now}]
  def attributes(attvalues=[])
    return "" if attvalues.nil?
    attribute_data = %{\t\t\t\t<attvalues>\n}
    attvalues.each do |attvalue|
      attribute_data += attribute(attvalue)
    end
    attribute_data += %{\t\t\t\t</attvalues>\n}
    return attribute_data
  end
  
  def attribute(attvalue)
    attvalue_gexf = %{\t\t\t\t\t<attvalue }
    attvalue.each_pair do |key, value|
      attvalue_gexf += %{#{key}="#{value}" }
    end
    attvalue_gexf += %{/>\n}
    attvalue_gexf
  end
  
  #slices look like [{:start => Time.now-24*60*60*7, :end => Time.now}]
  def slices(slices=[])
    return "" if slices.nil?
    slice_data = %{\t\t\t\t<slices>\n}
    slices.each do |slice_data|
      slice_data += slice(slice_data)
    end
    slice_data += %{\t\t\t\t</slices>\n}
    return slice_data
  end
  
  def slice(slice)
    slice_gexf = %{\t\t\t\t\t<slice }
    slice.each_pair do |key, value|
      slice_gexf += %{#{key}="#{value}" }
    end
    slice_gexf += %{/>\n}
    write(slice_gexf)
  end
  
  #edges look like: [{:source => "peat", :target => "dgaff", :start => Time.now-24*60*60*7, :end => Time.now, :attributes => [{:for => "attribute_name", :value => 1, :start => Time.now-24*60*60*7, :end => Time.now}], :slices => [{:start => Time.now-24*60*60*7, :end => Time.now}]}]
  def edges(edges)
    edges.each do |edge|
      edge(edge)
    end
  end

  #edges look like: {:source => "peat", :target => "dgaff", :start => Time.now-24*60*60*7, :end => Time.now, :attributes => [{:for => "attribute_name", :value => 1, :start => Time.now-24*60*60*7, :end => Time.now}], :slices => [{:start => Time.now-24*60*60*7, :end => Time.now}]}  
  def edge(edge)
    edge_data = %{\t\t\t<edge source="#{edge[:source]}" target="#{edge[:target]}"}
    (edge_data += %{ start="#{edge[:start]}"}) if edge[:start]
    (edge_data += %{ end="#{edge[:end]}"}) if edge[:start]
    edge_data += %{>\n}
    edge_data += attributes(edge[:attributes])
    edge_data += slices(edge[:slices])
    edge_data += %{\t\t\t</edge>\n}
    write(edge_data)
  end
  
  #nodes look like: {:id => "peat", :label => "Peat Bakke", :start => Time.now-24*60*60*7, :end => Time.now, :attributes => [{:for => "attribute_name", :value => 1, :start => Time.now-24*60*60*7, :end => Time.now}], :slices => [{:start => Time.now-24*60*60*7, :end => Time.now}]}    
  def nodes(nodes)
    nodes.each do |node|
      node(node)
    end
  end
  
  def node(node)
    node_data = %{\t\t\t<node id="#{node[:id]}" label="#{node[:label]}"}
    (node_data += %{ start="#{node[:start]}"}) if node[:start]
    (node_data += %{ end="#{node[:end]}"}) if node[:start]
    node_data += %{>\n}
    node_data += attributes(node[:attributes])
    node_data += slices(node[:slices])
    node_data += %{\t\t\t</node>\n}
    write(node_data)
  end
  
  def footer
    write(%{\t</graph>\n</gexf>\n})
  end
end
