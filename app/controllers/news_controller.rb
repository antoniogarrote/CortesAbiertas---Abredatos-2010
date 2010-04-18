class NewsController < ApplicationController

	def index

		require 'ostruct'
		require 'net/http'
		require 'rexml/document'



		url = 'http://www.ccyl.es/cms/actualidad/listado.rss'

		# get the XML data as a string
		xml_data = Net::HTTP.get_response(URI.parse(url)).body

		# extract event information
		doc = REXML::Document.new(xml_data)

		news = []


		id = 0
		REXML::XPath.each( doc, "//item") do |element|
			o = OpenStruct.new
			element.elements.each() do |child|
				if child.name == "title"
					o.title = child.text
				end
				if child.name == "pubDate"
					o.date = child.text
				end
				if child.name == "description"
					o.des = child.text
				end
				if child.name == "link"
					o.link = child.text
				end
			end
			id += 1
			o.id = id
			news << o

		end

		@news = news.reverse
	end
end
