module.exports = {
	apps: [
		//
		{
			name: "server",
			script: "./app.js"
		},
		//
		{
			script: "serve",
			env: {
				PM2_SERVE_PATH: './web_user',
				PM2_SERVE_PORT: 1001
			}
		},
		{
			script: "serve",
			env: {
				PM2_SERVE_PATH: './web_admin',
				PM2_SERVE_PORT: 1002
			}
		}
	]
}