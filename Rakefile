require 'foodcritic'
task :default => [:foodcritic]
FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    :exclude_paths => ['spec/**/*'],
    :tags => ['~FC034']
  }
end
