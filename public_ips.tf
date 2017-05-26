resource "azurerm_public_ip" "test_public_ip" {
  name = "${var.prefix}-test-public-ip-${var.suffix}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location = "${var.location}"

  public_ip_address_allocation = "static"

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}
