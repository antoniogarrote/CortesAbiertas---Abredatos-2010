require 'open-uri'
require 'date'
require 'rubygems'
require 'nokogiri'


URL = "http://2004.ccyl.es/Iniciativas/TiposIniciativa.aspx?"
INITIATIVES = [
  { :code => 'A', :desc => 'Acuerdos' },
  { :code => 'AD', :desc => 'Asuntos Diversos' },
  { :code => 'CJCYL', :desc => 'Comunicaciones de la Junta de CyL' },
  { :code => 'C', :desc => 'Convenios' },
  { :code => 'DI', :desc => 'Declaraciones Institucionales' },
  { :code => 'DLEY', :desc => 'Decreto Ley' },
  { :code => 'DL', :desc => 'Decretos Legislativos' },
  { :code => 'IA', :desc => 'Informaciones de Actualidad' },
  { :code => 'IAPC', :desc => 'Informes anuales del Procurador del Común' },
  { :code => 'IEPC', :desc => 'Informes del Procurador del Común' },
  { :code => 'I', :desc => 'Interpelaciones' },
  { :code => 'M', :desc => 'Mociones' },
  { :code => 'ON', :desc => 'Otras Normas' },
  { :code => 'PE', :desc => 'Preguntas Escritas' },
  { :code => 'PO', :desc => 'Preguntas Orales' },
  { :code => 'POC', :desc => 'Preguntas Orales en Comisión' },
  { :code => 'POP', :desc => 'Preguntas Orales en Pleno' },
  { :code => 'PC', :desc => 'Procurador del Común' },
  { :code => 'PPL', :desc => 'Proposiciones de Ley' },
  { :code => 'ILP', :desc => 'Proposiciones de Ley de Iniciativa Legislativa Popular y de los Ayuntamientos de CyL' },
  { :code => 'PNL', :desc => 'Proposiciones no de Ley' },
  { :code => 'PREA', :desc => 'Propuestas de Reforma del Estatuto de Autonomía' },
  { :code => 'PRR', :desc => 'Propuestas de Reforma del Reglamento de las Cortes de CyL' },
  { :code => 'PR', :desc => 'Propuestas de Resolución' },
  { :code => 'PL', :desc => 'Proyectos de Ley' },
  { :code => 'REG', :desc => 'Reglamento' },
  { :code => 'SD', :desc => 'Solicitudes de Documentación' },
  { :code => 'SC', :desc => 'Solucitudes de Comparecencia' },
  { :code => 'TC', :desc => 'Tribunal Constitucional' }
]

def crawl_initiative cod, n
  leg = 7
  (1..n).to_a.reverse.each do |i|
    begin
      doc = Nokogiri::HTML(open("http://2004.ccyl.es/Iniciativas/Ficha.aspx?Entidad=EXP&Leg=#{leg}&Cod=#{cod}&Num=#{i}"))
      initiative = parse_initiative(doc)
      Initiative.create(initiative.merge(:number => i, :type => cod, :legislation => leg)) if initiative
      print '.'
    rescue Exception => e
      puts e.message
    end
  end
end

def parse_initiative doc
  p_nodes = doc.xpath("//div[@id='dApartado']/p")
  return nil unless p_nodes
  {
    :description => p_nodes[0].content,
    :published_at => Date.parse(p_nodes[1].content.split(', ').last)
  }
end

INITIATIVES.each do |i|
  latest_initiative = nil
  open(URI("#{URL}TIniciativa=#{i[:code]}")) do |f|
    print "crawling #{i[:desc]} "
    initiative_lines = []
    f.each_line{ |l| initiative_lines << $1 if l.match(/NumeroExpediente="(\d+)"/) }
    latest_initiative = initiative_lines.first.to_i unless initiative_lines.empty?
  end

  crawl_initiative(i[:code], latest_initiative) if latest_initiative
  puts ""
end