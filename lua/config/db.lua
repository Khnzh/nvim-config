local e = os.getenv

local function pg_url(host, port, user, password, db)
	return string.format(
		"postgresql://%s:%s@%s:%s/%s?sslmode=disable",
		user or "", password or "", host or "", port or "", db or ""
	)
end

return {
	{
		name = "stage3",
		dadbod_name = "axi4utf (read-only)",
		type = "postgres",
		url = pg_url(e("AXI4UTF_HOST"), e("AXI4UTF_PORT"), e("AXI4UTF_USER"), e("AXI4UTF_PASSWORD"), e("AXI4UTF_DB")),
	},
	{
		name = "pgvector",
		dadbod_name = "pgvector",
		type = "postgres",
		url = pg_url(e("PGVECTOR_HOST"), e("PGVECTOR_PORT"), e("PGVECTOR_USER"), e("PGVECTOR_PASSWORD"), e("PGVECTOR_DB")),
	},
	{
		name = "stage1",
		type = "postgres",
		url = pg_url(e("DBEE_STAGE1_HOST"), e("DBEE_STAGE1_PORT"), e("AXREAD_USER"), e("AXREAD_PASSWORD"), e("DBEE_STAGE1_DB")),
	},
	{
		name = "toir",
		type = "postgres",
		url = pg_url(e("DBEE_TOIR_HOST"), e("DBEE_TOIR_PORT"), e("AXREAD_USER"), e("AXREAD_PASSWORD"), e("DBEE_TOIR_DB")),
	},
	{
		name = "nf-dev",
		type = "postgres",
		url = pg_url(e("DBEE_NFDEV_HOST"), e("DBEE_NFDEV_PORT"), e("AXREAD_USER"), e("AXREAD_PASSWORD"), e("DBEE_NFDEV_DB")),
	},
}
