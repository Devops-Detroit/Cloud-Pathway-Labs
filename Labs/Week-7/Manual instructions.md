
### 1. Verify Peering with Network Access Analyzer
1. Navigate to VPC Dashboard → select "Network Access Analyzer" from the left menu
2. Click "Create Network Access Scope"
3. Configure:
   - Name: `VPC-A-to-VPC-B-Scope`
   - Source: Select "Network Interfaces" and choose the network interface attached to Instance A (in `Devops-Detroit-VPC-A`)
   - Destination: Select "Network Interfaces" and choose the network interface attached to Instance B (in `Devops-Detroit-VPC-B`)
4. Click "Create Network Access Scope"
5. Select the scope → click "Analyze"
6. Wait for the analysis to complete
7. Review findings:
   - A result with no findings confirms the path between Instance A and Instance B is accessible via the peering connection
   - Any findings indicate network access issues to investigate
8. In VPC Dashboard, confirm peering connection status shows "Active"
9. Verify both route tables contain the peering routes
10. In CloudWatch, confirm both log groups exist under `/aws/vpc/flow-logs/`
11. After generating some traffic, verify log streams appear in each log group
