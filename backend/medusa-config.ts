import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    redisUrl: process.env.REDIS_URL,
    http: {
      storeCors: process.env.STORE_CORS || "http://localhost:3000,https://reparagymstore.com",
      adminCors: process.env.ADMIN_CORS || "http://localhost:7001,https://admin.reparagymstore.com", 
      authCors: process.env.AUTH_CORS || "http://localhost:3000,https://reparagymstore.com",
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
      serverUrl: process.env.SERVER_URL || "http://localhost:9000",
    },
    workerMode: process.env.MEDUSA_WORKER_MODE || "shared"
  },
  admin: {
    disable: process.env.DISABLE_MEDUSA_ADMIN === "true",
    path: "/admin"
  },
  modules: [
    {
      resolve: "@medusajs/file-local",
      options: {
        upload_dir: "uploads",
        backend_url: process.env.BACKEND_URL || "http://localhost:9000"
      },
    },
  ]
})
