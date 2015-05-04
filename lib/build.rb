xml_template = File.read('./lib/template.xml')
html = File.read('./lib/HOA_app.html')
js_main = File.read('./lib/hangout.js')
output = File.open('./public/HOA_app.xml', 'w')

html.gsub!('$JS_PLACEHOLDER', js_main.to_s)
xml_template.gsub!('$HTML_PLACEHOLDER', html.to_s)

output << xml_template.to_s
output.close
