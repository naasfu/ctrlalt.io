require 'printnode'

class CreatePrintnodeService
  def self.call(file_to_print_url, title, printer_name, file_type='pdf_uri', source='ctrlalt.io')
    auth   = PrintNode::Auth.new(ENV['printnode_api_key'])

    client = PrintNode::Client.new(auth)

    begin
      if client.printers.any?
        printer = client.printers.find { |printer| printer.name == printer_name }
        
        if printer.nil?
          raise "No printer found with name '#{printer_name}'. Available printer names are: #{client.printers.map(&:name).join(', ')}."
        end
      else
        raise 'No printers available.'
      end
    rescue
      raise 'Invalid credentials.'
    end

    setup     = PrintNode::PrintJob.new(printer.id, title, file_type, file_to_print_url, source)
    print_job = client.create_printjob(setup, { expireAfter: 120000 })
    
    client.printjobs(print_job)
  end
end