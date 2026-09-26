### 3. FRRouting (`vtysh`) BGP Engine Tuning
Overcame FRR 8.4+ route suppression by injecting a static Null0 RIB entry for `10.1.1.0/24`, disabling `ebgp-requires-policy`, and binding explicit `PERMIT-ALL` outbound route maps[cite: 8, 10]:

```text
configure terminal
!
ip route 10.1.1.0/24 Null0
!
route-map PERMIT-ALL permit 10
exit
!
router bgp 65001
 neighbor 10.0.2.4 remote-as 65515
 neighbor 10.0.2.4 route-map PERMIT-ALL out
 neighbor 10.0.2.5 remote-as 65515
 neighbor 10.0.2.5 route-map PERMIT-ALL out
 network 10.1.1.0/24
 no bgp ebgp-requires-policy
end
write memory
clear ip bgp 10.0.2.4 soft out
clear ip bgp 10.0.2.5 soft out
```