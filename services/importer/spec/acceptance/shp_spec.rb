# encoding: utf-8
require_relative '../../lib/importer/runner'
require_relative '../../lib/importer/job'
require_relative '../../lib/importer/downloader'
require_relative '../factories/pg_connection'
require_relative '../doubles/log'
require_relative '../doubles/user'
require_relative 'acceptance_helpers'
require_relative 'cdb_importer_context'

include CartoDB::Importer2

describe 'SHP regression tests' do
  include AcceptanceHelpers
  include_context 'cdb_importer schema'

  before do
    @pg_options  = Factories::PGConnection.new.pg_options
  end

  it 'imports SHP files' do
    filepath    = path_to('TM_WORLD_BORDERS_SIMPL-0.3.zip')
    downloader  = Downloader.new(filepath)
    runner      = Runner.new({
                               pg: @pg_options,
                               downloader: downloader,
                               log: CartoDB::Importer2::Doubles::Log.new,
                               user:CartoDB::Importer2::Doubles::User.new
                             })
    runner.run

    geometry_type_for(runner).should be
  end

end # SHP regression tests
 
