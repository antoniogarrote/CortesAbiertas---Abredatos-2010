module InterventionsHelper
  def data_json_interventions(session)
    js = StringIO.new
    js << "SessionDataCortesAbiertasNouns = {"
    js << "nouns: "
    js << session.all_top_nouns(15).map{ |w| w.to_hash }.to_json
    js << "};"

    js << "SessionDataCortesAbiertasVerbs = {"
    js << "verbs: "
    js << session.all_top_verbs(15).map{ |w| w.to_hash }.to_json
    js << "};"


    js << "SessionDataCortesAbiertasAdjs = {"
    js << "adjs: "
    js << session.all_top_adjs(15).map{ |w| w.to_hash }.to_json
    js << "}"

    return js.string
  end
end
