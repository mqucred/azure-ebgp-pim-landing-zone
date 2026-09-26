Section A: Linux NVA BGP Validation (Phase 3 Control Plane)

Run on peer-linux-vm (10.0.1.4) via SSH:

#!/bin/bash
# Check BGP Neighbor Status with Azure Route Server (10.0.2.4 & 10.0.2.5)
sudo vtysh -c "show ip bgp summary"

# Check Advertised Routes to Route Server (Expecting 10.1.1.0/24)
sudo vtysh -c "show ip bgp"
