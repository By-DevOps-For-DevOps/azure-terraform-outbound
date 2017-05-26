//--------------------------------- LB --------------------------------------------
resource "azurerm_lb_probe" "proxy_lb_probe_22" {
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}-proxy-lb-probe-22-${var.suffix}"
  loadbalancer_id = "${azurerm_lb.proxy_lb.id}"
  port = 22
  interval_in_seconds = 5
  number_of_probes = 2
}

resource "azurerm_lb_rule" "proxy_lb_rule_80" {
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}-proxy-lb-rule-80-${var.suffix}"
  frontend_ip_configuration_name = "frontend-pool"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  loadbalancer_id = "${azurerm_lb.proxy_lb.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id = "${azurerm_lb_probe.proxy_lb_probe_22.id}"
  enable_floating_ip = true
}


resource "azurerm_lb_rule" "proxy_lb_rule_443" {
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}-proxy-lb-rule-443-${var.suffix}"
  frontend_ip_configuration_name = "frontend-pool"
  protocol = "Tcp"
  frontend_port = 443
  backend_port = 443
  loadbalancer_id = "${azurerm_lb.proxy_lb.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id = "${azurerm_lb_probe.proxy_lb_probe_22.id}"
  enable_floating_ip = true
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}-backend-pool-${var.suffix}"

  loadbalancer_id = "${azurerm_lb.proxy_lb.id}"
}

resource "azurerm_lb" "proxy_lb" {
  name = "${var.prefix}-proxy-lb-${var.suffix}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location = "${var.location}"

  frontend_ip_configuration {
    name = "frontend-pool"
    private_ip_address = "${var.proxy_lp_ip}"
    subnet_id = "${azurerm_subnet.proxy_subnet.id}"
    private_ip_address_allocation = "static"
  }
}