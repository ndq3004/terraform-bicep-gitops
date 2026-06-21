output "server_id" {
  value = azurerm_mssql_server.this.id
}

output "server_name" {
  value = azurerm_mssql_server.this.name
}

output "database_name" {
  value = azurerm_mssql_database.this.name
}

output "admin_password" {
  value     = coalesce(var.administrator_login_password, random_password.admin.result)
  sensitive = true
}
