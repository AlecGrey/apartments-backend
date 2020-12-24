require 'nokogiri'
require 'open-uri'
require 'pry'
require 'watir'
# Quick integer lookup dictionary
integers = {'0': true, '1': true, '2': true, '3': true, '4': true, '5': true, '6': true, '7': true, '8': true, '9':true }

# Empty DB - comment out if adding multiple pages to DB!
Image.destroy_all
Apartment.destroy_all
Neighborhood.destroy_all

# Use nokogiri to scrape links to listing SHOW pages (~120 links per page)
doc = Nokogiri::HTML(open('https://sfbay.craigslist.org/search/sfc/apa?hasPic=1&bundleDuplicates=1&availabilityMode=0&sale_date=all+dates'))
listitems = doc.css('li.result-row')
ri = listitems.css('.result-image')
arr = ri.css('a')
links = arr.map { |item| item['href'] }
# open browser instance
browser = Watir::Browser.new(:chrome)
# Iterate over each link: visit the page and scrape data to DB
links.each_with_index do |link, i|
    # navigate to the link
    browser.goto(link)
    # log page once it has been navigated to (for debugging)
    puts i
    # skip iteration if there are no image thumbs -> only want listings with images
    next if !browser.a(class: 'thumb').exists?
    # find and click each thumb on the page
    # This assures we can access all image URLS for scraping!
    browser.as(class: 'thumb').each { |th| th.click }
    # get HTML from page after all clicks
    # Begin scraping data!
    current_doc = Nokogiri::HTML.parse(browser.html)
    # Find square feet
    sq_ft_span = current_doc.at_css('p.attrgroup').children[3]
    # Some pages don't report sq_feet, short-circuit if it isn't found
    if sq_ft_span && integers[sq_ft_span.text[0].to_sym]
        sq_feet = sq_ft_span.text.split('ft')[0]
    else
        sq_feet = nil
    end
    # Find remaining variables
    price = current_doc.css('span.price').text.sub('$', '').sub(',', '').to_i
    neighborhood = current_doc.at_css('small').text.strip[1, neighborhood.length - 2]
    bed = current_doc.css('span.shared-line-bubble').children[0].text[0].to_i
    bath = current_doc.css('span.shared-line-bubble').children[2].text[0].to_i
    title = current_doc.css('span#titletextonly').text
    description = current_doc.css('#postingbody').text
    # Construct array of all image URLs
    # First image has unique path, all subsequent follow consistent path
    arr = []
    arr << current_doc.css('.slide > img')[0]['src']
    current_doc.css('.slide > picture > source').each do |el|
        arr << el['srcset']
    end
    # Add all scraped data to database
    neighborhood = Neighborhood.find_or_create_by(name: neighborhood)
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