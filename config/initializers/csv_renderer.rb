ActionController::Renderers.add :csv do |csv, options|
  filename = options[:filename] || csv.filename || options[:template]
  #csv.extend RenderCsv::CsvRenderable unless csv.respond_to?(:to_csv)
  data = csv.to_csv
  send_data data, type: Mime::CSV, disposition: "attachment; filename=#{filename}.csv"
end