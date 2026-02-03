# RHACM Knowledge Graph Extensions

This directory contains extension Cypher files that add specialized subsystems to the base RHACM knowledge graph.

## Loading Order

Extensions are loaded AFTER the base graph:

```bash
# 1. Load base graph first
cypher-shell < ../rhacm_architecture_comprehensive_final.cypher

# 2. Load extensions
for ext in *.cypher; do
  cypher-shell < "$ext"
done
```

## Available Extensions

| File | Components | Relationships | Description |
|------|------------|---------------|-------------|
| `rhacm-virtualization.cypher` | 48 | 60 | OpenShift Virtualization, MTV, CCLM, Fine-Grained RBAC |

## Extension Guidelines

### Use MERGE Statements
Extensions should use `MERGE` instead of `CREATE` to safely add components:

```cypher
// GOOD - Safe to run multiple times
MERGE (n:RHACMComponent {id: 'MY_COMPONENT'})
SET n.label = 'My Component', n.subsystem = 'Virtualization';

// BAD - Creates duplicates if run twice
CREATE (:RHACMComponent {id: 'MY_COMPONENT', label: 'My Component'});
```

### Reference Base Graph Nodes
Extensions can reference nodes from the base graph:

```cypher
// Reference existing CONSOLE node from base graph
MATCH (console:RHACMComponent {id: 'CONSOLE'})
MATCH (plugin:RHACMComponent {id: 'MY_PLUGIN'})
MERGE (console)-[:CONTAINS]->(plugin);
```

### Include Verification Metadata
Document where components were verified:

```cypher
MERGE (n:RHACMComponent {id: 'MY_COMPONENT'})
SET n.verified_cluster = 'cluster-name',
    n.verification_date = '2026-02-02',
    n.namespace = 'openshift-my-namespace';
```

## Virtualization Extension Details

The `rhacm-virtualization.cypher` extension covers:

### CNV/KubeVirt Stack
- HyperConverged Cluster Operator (HCO)
- KubeVirt Operator
- CDI (Containerized Data Importer)
- SSP (Scheduling, Scale, Performance)

### MTV (Migration Toolkit for Virtualization)
- Forklift Operator
- Forklift Controller
- Provider Controller (vSphere, oVirt, OpenStack, OVA, Hyper-V)
- Validation Service

### CCLM (Cross-Cluster Live Migration)
- Multi-cluster VM migration components
- MTVAddon for managed clusters

### Fine-Grained RBAC
- ClusterPermission CRD
- ManagedClusterRoleAssignment (MCRA)
- RBAC Addon

### Fleet Virtualization
- Console plugins (kubevirt-plugin, forklift-console-plugin)
- Fleet Virtualization Tree View
- VM Actions and management

**Verification**: All components verified against ACM 2.x with CNV 4.20+ and MTV 2.10+

## Contributing

1. Create your extension as a `.cypher` file
2. Use `MERGE` statements for safety
3. Include verification metadata
4. Update this README with your extension details
5. Submit a PR
