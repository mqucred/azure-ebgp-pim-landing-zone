In-VM Connectivity & Routing Check Commands (Bash via Serial Console / Private SSH):To test network accessibility and resolution across the Private Endpoint (10.1.2.4) and Standard Load Balancer Frontend (10.1.1.4) from inside the Spoke VM:   Bash# 1. Verify local interface IP configuration
ip addr show

# 2. Test TCP port connectivity to ILB Frontend (10.1.1.4)
nc -zv 10.1.1.4 80

# 3. Test TCP port connectivity across Private Endpoint (10.1.2.4)
nc -zv 10.1.2.4 80

# 4. Verify HTTP response headers via Private Endpoint
curl -I http://10.1.2.4/