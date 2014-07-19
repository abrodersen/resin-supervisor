Promise = require 'bluebird'
Knex = require 'knex'

knex = Knex.initialize(
	client: 'sqlite3'
	connection:
		filename: '/data/database.sqlite'
)

knex.init = Promise.all([
	knex.schema.hasTable('config')
	.then (exists) ->
		if not exists
			knex.schema.createTable 'config', (t) ->
				t.string('key').primary()
				t.string('value')

	knex.schema.hasTable('app')
	.then (exists) ->
		if not exists
			knex.schema.createTable 'app', (t) ->
				t.increments('id').primary()
				t.string('name')
				t.string('containerId')
				t.string('commit')
				t.string('imageId')
				t.boolean('privileged')
				t.json('env')
		else
			knex.schema.hasColumn('app', 'commit')
			.then (exists) ->
				if not exists
					knex.schema.table 'app', (t) ->
						t.string('commit')

])

module.exports = knex
