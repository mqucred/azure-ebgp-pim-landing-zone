Section C: Private Link Service & Endpoint Testing (Phase 4 Data Plane)

Run from a Spoke VM inside vnet-spoke-001:

#!/bin/bash
# 1. Test TCP 80 Listener on Private Endpoint pe-app-001
nc -zv 10.1.2.4 80

# 2. Query HTTP Endpoint across Private Link Service (pls-cross-boundary-001)
curl -I http://10.1.2.4/