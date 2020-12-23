# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'watir'

Image.destroy_all
Apartment.destroy_all
Neighborhood.destroy_all

doc = Nokogiri::HTML(open('https://sfbay.craigslist.org/search/sfc/apa?hasPic=1&bundleDuplicates=1&availabilityMode=0&sale_date=all+dates'))
# find the item links!
listitems = doc.css('li.result-row')
ri = listitems.css('.result-image')
arr = ri.css('a')
links = arr.map { |item| item['href'] }

integers = {'0': true, '1': true, '2': true, '3': true, '4': true, '5': true, '6': true, '7': true, '8': true, '9':true }

# open browser instance
browser = Watir::Browser.new(:chrome)

link_array = []

links.each_with_index do |link, i|
    # navigate to the link
    browser.goto(link)
    # log iteration
    puts i

    # skip iteration if there are no image thumbs
    next if !browser.a(class: 'thumb').exists?
    # find and click each thumb on the page
    browser.as(class: 'thumb').each { |th| th.click }
    # get HTML from page after all clicks
    current_doc = Nokogiri::HTML.parse(browser.html)

    

    sq_ft_span = current_doc.at_css('p.attrgroup').children[3]

    #  ~~ ALL VARIABLES DEFINED BELOW ~~ #
    if sq_ft_span && integers[sq_ft_span.text[0].to_sym]
        sq_feet = sq_ft_span.text.split('ft')[0]
    else
        sq_feet = nil
    end
    
    price = current_doc.css('span.price').text.sub('$', '').sub(',', '').to_i
    neighborhood = current_doc.at_css('small').text.strip
    bed = current_doc.css('span.shared-line-bubble').children[0].text[0].to_i
    bath = current_doc.css('span.shared-line-bubble').children[2].text[0].to_i
    title = current_doc.css('span#titletextonly').text
    description = current_doc.css('#postingbody').text
    
    # ~ Construct array with new dataset ~ #
    arr = []

    arr << current_doc.css('.slide > img')[0]['src']
    
    current_doc.css('.slide > picture > source').each do |el|
        arr << el['srcset']
    end

    # link_array << { 
    #     images: arr,
    #     neighborhood: neighborhood,
    #     price: price,
    #     square_feet: sq_feet,
    #     bed: bed,
    #     bath: bath,
    #     title: title,
    #     description: description
    # }

    neighborhood = Neighborhood.find_or_create_by(name: neighborhood[1, neighborhood.length - 2])
    apartment = Apartment.create(
        price: price,
        square_feet: sq_feet,
        bedrooms: bed,
        bathrooms: bath,
        title: title,
        description: description
    )
    arr.each { |image_url| apartment.images << Image.create( url: image_url ) }

    neighborhood.apartments << apartment

end