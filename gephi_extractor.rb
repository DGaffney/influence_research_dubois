class GephiExtractor
  def self.run(data)
    data = Hashie::Mash[data]
    gexf_network = Nokogiri::parse(data.gexf_network)
    nodes = []
    edges = []
    communities = {}
    gexf_network.search("node").each do |node_data|
      node = self.parse_node(node_data)
      nodes << node
      community_id = node[:attributes].select{|k| k[:for] == "modularity_class"}.first[:value]
      if communities[community_id]
        communities[community_id][:id] = community_id
        communities[community_id][:ids] << node[:id]
        communities[community_id][:nodes_count]+=1
      else
        communities[community_id] = {}
        communities[community_id][:ids] = [node[:id]]
        communities[community_id][:color] = node[:color]
        communities[community_id][:edges_count] = 0
        communities[community_id][:nodes_count] = 1
      end
    end
    # gexf_network.search("edge").each do |edge_data|
    #   edge = self.parse_edge(edge_data)
    #   source_node = nodes.select{|n| n[:id] == edge[:source]}.first
    #   source_community_id = source_node[:attributes].select{|k| k[:for] == "modularity_class"}.first[:value]
    #   communities[source_community_id][:edges_count] += 1
    #   edges << edge
    # end
    return {:nodes => nodes, :edges => edges, :communities => communities}
  end

  def self.parse_node(node_data)
    node = {}
    node[:id] = node_data.attributes["id"].value
    node[:label] = node_data.attributes["label"].value
    node[:attributes] = []
    node_data.search("attvalue").each do |attribute_data|
      attribute = {}
      attribute[:for] = attribute_data.attributes["for"].value
      attribute[:value] = attribute_data.attributes["value"].value
      node[:attributes] << attribute      
    end
    node[:size] = node_data.search("viz|size").first.attributes["value"].value
    node[:position] = {}
    position = node_data.search("viz|position").first
    node[:position][:x] = position.attributes["x"].value
    node[:position][:y] = position.attributes["y"].value
    node[:position][:z] = position.attributes["z"].value
    node[:color] = {}
    color = node_data.search("viz|color").first
    node[:color][:r] = color.attributes["r"].value
    node[:color][:g] = color.attributes["g"].value
    node[:color][:b] = color.attributes["b"].value
    return node
  end
  
  def self.parse_edge(edge_data)
    edge = {}
    edge[:source] = edge_data.attributes["source"].value
    edge[:target] = edge_data.attributes["target"].value
    edge[:weight] = edge_data.attributes["weight"].value rescue 1
    edge[:attributes] = []
    edge_data.search("attvalue").each do |attribute_data|
      attribute = {}
      attribute[:for] = attribute_data.attributes["for"].value
      attribute[:value] = attribute_data.attributes["value"].value
      edge[:attributes] << attribute
    end
    return edge
  end

end