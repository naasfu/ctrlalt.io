###
### PAYPAL
################################################################################

namespace :paypal do
  desc "Upload paypal certs"
  task :upload do
    scp_upload("#{app_root}/certs/paypal/{app_cert,app_key,paypal_cert}.pem", "#{deploy_to}/#{shared_path}/certs/paypal", verbose: true)
  end

  desc "Create paypal cert directory"
  task :setup do
    queue %[mkdir -p "#{deploy_to}/#{shared_path}/certs/paypal"]
    queue %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/certs/paypal"]
  end
end