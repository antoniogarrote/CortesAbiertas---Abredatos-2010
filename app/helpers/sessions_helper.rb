module SessionsHelper
  def data_json
    js = StringIO.new
    js << "SessionDataCortesAbiertasNouns = {"
    Session.all.each_with_index do |s,i|
      if i != 0
        js << " , "
      end
      js << "session_#{s.id}: "
      js << s.all_top_nouns.map{ |w| w.to_hash }.to_json
    end
    js << "};"

    js << "SessionDataCortesAbiertasVerbs = {"
    Session.all.each_with_index do |s,i|
      if i != 0
        js << " , "
      end
      js << "session_#{s.id}: "
      js << s.all_top_verbs.map{ |w| w.to_hash }.to_json
    end
    js << "};"


    js << "SessionDataCortesAbiertasAdjs = {"
    Session.all.each_with_index do |s,i|
      if i != 0
        js << " , "
      end
      js << "session_#{s.id}: "
      js << s.all_top_adjs.map{ |w| w.to_hash }.to_json
    end
    js << "}"

    return js.string
  end
end
