task before_assets_precompile: :environment do
    puts "Running yarn..."
    system('yarn run')
  end
  
  # every time you execute 'rake assets:precompile'
  # run 'before_assets_precompile' first
  Rake::Task['assets:precompile'].enhance ['before_assets_precompile']