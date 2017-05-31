DataMapper.setup(:default, "postgres://localhost/bookmark_manager_dev")
DataMapper.finalize
DataMapper.auto_upgrade!