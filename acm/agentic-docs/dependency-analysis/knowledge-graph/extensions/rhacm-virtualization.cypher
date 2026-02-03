// ============================================================================
// RHACM Knowledge Graph Extension: Virtualization, MTV, CCLM, Fine-Grained RBAC
// ============================================================================
// Generated: 2026-01-30
// Source: Deep investigation of kubevirt, kubev2v, stolostron repos and JIRA
// Components: 48 new components across 4 major feature areas
// Relationships: 60 new relationships (48 original + 12 orphan fixes)
// ============================================================================
//
// VERIFICATION STATUS: VERIFIED (Re-verified + Orphan Fixes)
// Verified Date: 2026-02-02
// Verified Cluster: slot-03.dev09.red-chesterfield.com (ACM Hub)
// Re-verification: Fixed MCRA naming (ManagedCluster -> MultiCluster)
// Orphan Fixes: Added 12 relationships for 9 previously orphaned nodes
// CNV Version: 4.20.3, MTV Version: 2.10.3, ACM: 2.x with FG-RBAC enabled
//
// Verification Method:
// - Live cluster resource inspection (read-only)
// - GitHub repository code analysis (kubevirt, kubev2v, stolostron orgs)
// - CRD and operator structure validation
//
// Key Verified Resources:
// - HCO: kubevirt-hyperconverged-operator.v4.20.3
// - CDI: cdi-kubevirt-hyperconverged (Deployed)
// - SSP: ssp-kubevirt-hyperconverged (Deployed)
// - MTV: mtv-operator.v2.10.3, forklift-controller (Running)
// - Addons: kubevirt-hyperconverged, mtv-operator ClusterManagementAddons
// - RBAC: ClusterPermission CRD, kubevirt.io:admin/edit/view roles
// - Providers: local-cluster-mtv, slot-04-mtv (CCLM targets)
// - Console: kubevirt-plugin, forklift-console-plugin
//
// Total Graph After Update: 348 components, 483 relationships
// ============================================================================

// ============================================================================
// SECTION 1: CNV/KUBEVIRT CORE STACK (OpenShift Virtualization)
// ============================================================================

// --- HyperConverged Cluster Operator (Meta-Operator) ---
MERGE (hco:RHACMComponent {id: 'HCO_OPERATOR'})
ON CREATE SET 
  hco.label = 'HyperConverged Cluster Operator',
  hco.subsystem = 'Cluster',
  hco.type = 'Operator',
  hco.description = 'Meta-operator that deploys and manages all CNV components (KubeVirt, CDI, SSP, CNAO)';

// --- KubeVirt Core ---
MERGE (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
ON CREATE SET 
  kubevirt.label = 'KubeVirt Operator',
  kubevirt.subsystem = 'Cluster',
  kubevirt.type = 'Operator',
  kubevirt.description = 'Core virtualization operator providing VirtualMachine and VirtualMachineInstance CRDs';

MERGE (kubevirt_api:RHACMComponent {id: 'KUBEVIRT_API'})
ON CREATE SET 
  kubevirt_api.label = 'KubeVirt API',
  kubevirt_api.subsystem = 'Cluster',
  kubevirt_api.type = 'API',
  kubevirt_api.description = 'KubeVirt API definitions for VirtualMachine, VMI, DataVolume resources';

// --- Containerized Data Importer (CDI) ---
MERGE (cdi:RHACMComponent {id: 'CDI_OPERATOR'})
ON CREATE SET 
  cdi.label = 'Containerized Data Importer Operator',
  cdi.subsystem = 'Cluster',
  cdi.type = 'Operator',
  cdi.description = 'Manages persistent storage for VMs, populates PVCs with VM disk images';

MERGE (cdi_controller:RHACMComponent {id: 'CDI_CONTROLLER'})
ON CREATE SET 
  cdi_controller.label = 'CDI Controller',
  cdi_controller.subsystem = 'Cluster',
  cdi_controller.type = 'Controller',
  cdi_controller.description = 'Handles DataVolume creation and disk image import operations';

// --- SSP Operator (Scheduling, Scale, Performance) ---
MERGE (ssp:RHACMComponent {id: 'SSP_OPERATOR'})
ON CREATE SET 
  ssp.label = 'SSP Operator',
  ssp.subsystem = 'Cluster',
  ssp.type = 'Operator',
  ssp.description = 'Deploys VM templates, instance types, console proxy, and template validator';

MERGE (common_templates:RHACMComponent {id: 'COMMON_TEMPLATES'})
ON CREATE SET 
  common_templates.label = 'Common Templates',
  common_templates.subsystem = 'Cluster',
  common_templates.type = 'Component',
  common_templates.description = 'Pre-defined VM templates for common operating systems';

MERGE (common_instancetypes:RHACMComponent {id: 'COMMON_INSTANCETYPES'})
ON CREATE SET 
  common_instancetypes.label = 'Common Instance Types',
  common_instancetypes.subsystem = 'Cluster',
  common_instancetypes.type = 'Component',
  common_instancetypes.description = 'Predefined VM instance types and preferences (CPU, memory profiles)';

MERGE (vm_console_proxy:RHACMComponent {id: 'VM_CONSOLE_PROXY'})
ON CREATE SET 
  vm_console_proxy.label = 'VM Console Proxy',
  vm_console_proxy.subsystem = 'Cluster',
  vm_console_proxy.type = 'Component',
  vm_console_proxy.description = 'Provides VNC/serial console access to VMs';

// --- Cluster Network Addons Operator (CNAO) ---
MERGE (cnao:RHACMComponent {id: 'CNAO_OPERATOR'})
ON CREATE SET 
  cnao.label = 'Cluster Network Addons Operator',
  cnao.subsystem = 'Cluster',
  cnao.type = 'Operator',
  cnao.description = 'Deploys networking components for VM connectivity (Multus, bridges, MacVTap)';

MERGE (macvtap_cni:RHACMComponent {id: 'MACVTAP_CNI'})
ON CREATE SET 
  macvtap_cni.label = 'MacVTap CNI',
  macvtap_cni.subsystem = 'Cluster',
  macvtap_cni.type = 'Component',
  macvtap_cni.description = 'CNI plugin for MacVTap networking for VM workloads';

MERGE (linux_bridge_cni:RHACMComponent {id: 'LINUX_BRIDGE_CNI'})
ON CREATE SET 
  linux_bridge_cni.label = 'Linux Bridge CNI',
  linux_bridge_cni.subsystem = 'Cluster',
  linux_bridge_cni.type = 'Component',
  linux_bridge_cni.description = 'CNI plugin for Linux bridge networking';

MERGE (kubesecondarydns:RHACMComponent {id: 'KUBESECONDARYDNS'})
ON CREATE SET 
  kubesecondarydns.label = 'KubeSecondaryDNS',
  kubesecondarydns.subsystem = 'Cluster',
  kubesecondarydns.type = 'Component',
  kubesecondarydns.description = 'DNS service for VM secondary network interfaces';

// --- Other CNV Components ---
MERGE (hostpath_provisioner:RHACMComponent {id: 'HOSTPATH_PROVISIONER_OPERATOR'})
ON CREATE SET 
  hostpath_provisioner.label = 'HostPath Provisioner Operator',
  hostpath_provisioner.subsystem = 'Cluster',
  hostpath_provisioner.type = 'Operator',
  hostpath_provisioner.description = 'Provides local storage for VMs using hostPath volumes';

MERGE (node_maintenance:RHACMComponent {id: 'NODE_MAINTENANCE_OPERATOR'})
ON CREATE SET 
  node_maintenance.label = 'Node Maintenance Operator',
  node_maintenance.subsystem = 'Cluster',
  node_maintenance.type = 'Operator',
  node_maintenance.description = 'Manages node maintenance operations for VM workloads';

MERGE (containerdisks:RHACMComponent {id: 'CONTAINERDISKS'})
ON CREATE SET 
  containerdisks.label = 'ContainerDisks',
  containerdisks.subsystem = 'Cluster',
  containerdisks.type = 'Component',
  containerdisks.description = 'Official container disk images for KubeVirt VMs';

// ============================================================================
// SECTION 2: MTV/FORKLIFT STACK (Migration Toolkit for Virtualization)
// ============================================================================

// --- MTV Operator ---
MERGE (mtv_operator:RHACMComponent {id: 'MTV_OPERATOR'})
ON CREATE SET 
  mtv_operator.label = 'MTV Operator',
  mtv_operator.subsystem = 'Cluster',
  mtv_operator.type = 'Operator',
  mtv_operator.description = 'Forklift operator for migrating VMs from VMware, oVirt, OpenStack to KubeVirt';

// --- Forklift Controllers ---
MERGE (forklift_controller:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
ON CREATE SET 
  forklift_controller.label = 'Forklift Controller',
  forklift_controller.subsystem = 'Cluster',
  forklift_controller.type = 'Controller',
  forklift_controller.description = 'Main migration controller managing Plans, Migrations, Providers';

MERGE (plan_controller:RHACMComponent {id: 'MTV_PLAN_CONTROLLER'})
ON CREATE SET 
  plan_controller.label = 'Plan Controller',
  plan_controller.subsystem = 'Cluster',
  plan_controller.type = 'Controller',
  plan_controller.description = 'Manages migration Plan resources and lifecycle';

MERGE (migration_controller:RHACMComponent {id: 'MTV_MIGRATION_CONTROLLER'})
ON CREATE SET 
  migration_controller.label = 'Migration Controller',
  migration_controller.subsystem = 'Cluster',
  migration_controller.type = 'Controller',
  migration_controller.description = 'Executes active VM migrations';

MERGE (provider_controller:RHACMComponent {id: 'MTV_PROVIDER_CONTROLLER'})
ON CREATE SET 
  provider_controller.label = 'Provider Controller',
  provider_controller.subsystem = 'Cluster',
  provider_controller.type = 'Controller',
  provider_controller.description = 'Manages source Provider resources (VMware, oVirt, OpenStack, OVA)';

MERGE (network_map_controller:RHACMComponent {id: 'MTV_NETWORK_MAP_CONTROLLER'})
ON CREATE SET 
  network_map_controller.label = 'NetworkMap Controller',
  network_map_controller.subsystem = 'Cluster',
  network_map_controller.type = 'Controller',
  network_map_controller.description = 'Manages network mapping between source and target';

MERGE (storage_map_controller:RHACMComponent {id: 'MTV_STORAGE_MAP_CONTROLLER'})
ON CREATE SET 
  storage_map_controller.label = 'StorageMap Controller',
  storage_map_controller.subsystem = 'Cluster',
  storage_map_controller.type = 'Controller',
  storage_map_controller.description = 'Manages storage mapping between source and target';

MERGE (hook_controller:RHACMComponent {id: 'MTV_HOOK_CONTROLLER'})
ON CREATE SET 
  hook_controller.label = 'Hook Controller',
  hook_controller.subsystem = 'Cluster',
  hook_controller.type = 'Controller',
  hook_controller.description = 'Manages pre/post migration hooks';

// --- Forklift API and Tools ---
MERGE (forklift_api:RHACMComponent {id: 'FORKLIFT_API'})
ON CREATE SET 
  forklift_api.label = 'Forklift API',
  forklift_api.subsystem = 'Cluster',
  forklift_api.type = 'API',
  forklift_api.description = 'REST API for Forklift/MTV operations';

MERGE (virt_v2v:RHACMComponent {id: 'VIRT_V2V'})
ON CREATE SET 
  virt_v2v.label = 'virt-v2v',
  virt_v2v.subsystem = 'Cluster',
  virt_v2v.type = 'Component',
  virt_v2v.description = 'Guest conversion tool for transforming VM disk formats';

// --- Volume Populators ---
MERGE (ovirt_populator:RHACMComponent {id: 'OVIRT_VOLUME_POPULATOR'})
ON CREATE SET 
  ovirt_populator.label = 'oVirt Volume Populator',
  ovirt_populator.subsystem = 'Cluster',
  ovirt_populator.type = 'Component',
  ovirt_populator.description = 'Populates PVCs with disk data from oVirt/RHV';

MERGE (openstack_populator:RHACMComponent {id: 'OPENSTACK_VOLUME_POPULATOR'})
ON CREATE SET 
  openstack_populator.label = 'OpenStack Volume Populator',
  openstack_populator.subsystem = 'Cluster',
  openstack_populator.type = 'Component',
  openstack_populator.description = 'Populates PVCs with disk data from OpenStack';

MERGE (vsphere_xcopy_populator:RHACMComponent {id: 'VSPHERE_XCOPY_VOLUME_POPULATOR'})
ON CREATE SET 
  vsphere_xcopy_populator.label = 'vSphere XCOPY Volume Populator',
  vsphere_xcopy_populator.subsystem = 'Cluster',
  vsphere_xcopy_populator.type = 'Component',
  vsphere_xcopy_populator.description = 'Storage offload populator using XCOPY for VMware migrations';

// --- Provider Servers ---
MERGE (ova_provider:RHACMComponent {id: 'OVA_PROVIDER_SERVER'})
ON CREATE SET 
  ova_provider.label = 'OVA Provider Server',
  ova_provider.subsystem = 'Cluster',
  ova_provider.type = 'Component',
  ova_provider.description = 'Handles OVA file imports as migration source';

MERGE (hyperv_provider:RHACMComponent {id: 'HYPERV_PROVIDER_SERVER'})
ON CREATE SET 
  hyperv_provider.label = 'Hyper-V Provider Server',
  hyperv_provider.subsystem = 'Cluster',
  hyperv_provider.type = 'Component',
  hyperv_provider.description = 'Handles Hyper-V as migration source';

// --- MTV Console Plugin ---
MERGE (forklift_console:RHACMComponent {id: 'FORKLIFT_CONSOLE_PLUGIN'})
ON CREATE SET 
  forklift_console.label = 'Forklift Console Plugin',
  forklift_console.subsystem = 'Console',
  forklift_console.type = 'Component',
  forklift_console.description = 'OpenShift Console plugin for MTV migration UI';

// --- Migration Planner ---
MERGE (migration_planner:RHACMComponent {id: 'MIGRATION_PLANNER'})
ON CREATE SET 
  migration_planner.label = 'Migration Planner',
  migration_planner.subsystem = 'Cluster',
  migration_planner.type = 'Component',
  migration_planner.description = 'VMware assessment service for migration readiness';

// ============================================================================
// SECTION 3: CCLM (Cross-Cluster Live Migration)
// ============================================================================

MERGE (cclm:RHACMComponent {id: 'CCLM'})
ON CREATE SET 
  cclm.label = 'Cross-Cluster Live Migration',
  cclm.subsystem = 'Cluster',
  cclm.type = 'Component',
  cclm.description = 'Live migration of running VMs between OpenShift clusters';

MERGE (kubevirt_migration_operator:RHACMComponent {id: 'KUBEVIRT_MIGRATION_OPERATOR'})
ON CREATE SET 
  kubevirt_migration_operator.label = 'KubeVirt Migration Operator',
  kubevirt_migration_operator.subsystem = 'Cluster',
  kubevirt_migration_operator.type = 'Operator',
  kubevirt_migration_operator.description = 'Operator for cross-cluster VM migration (CCLM)';

MERGE (kubevirt_migration_controller:RHACMComponent {id: 'KUBEVIRT_MIGRATION_CONTROLLER'})
ON CREATE SET 
  kubevirt_migration_controller.label = 'KubeVirt Migration Controller',
  kubevirt_migration_controller.subsystem = 'Cluster',
  kubevirt_migration_controller.type = 'Controller',
  kubevirt_migration_controller.description = 'Controller managing cross-cluster VM migration execution';

// ============================================================================
// SECTION 4: ACM INTEGRATION LAYER (MTV Integrations, Fleet Virtualization)
// ============================================================================

// --- MTV Integrations ---
MERGE (mtv_integrations:RHACMComponent {id: 'MTV_INTEGRATIONS'})
ON CREATE SET 
  mtv_integrations.label = 'MTV Integrations',
  mtv_integrations.subsystem = 'Cluster',
  mtv_integrations.type = 'Operator',
  mtv_integrations.description = 'ACM MTV integration controller, webhooks, and addon management';

MERGE (provider_manager_controller:RHACMComponent {id: 'PROVIDER_MANAGER_CONTROLLER'})
ON CREATE SET 
  provider_manager_controller.label = 'Provider Manager Controller',
  provider_manager_controller.subsystem = 'Cluster',
  provider_manager_controller.type = 'Controller',
  provider_manager_controller.description = 'Integrates ACM managed clusters as MTV providers';

MERGE (mtv_plan_webhook:RHACMComponent {id: 'MTV_PLAN_WEBHOOK'})
ON CREATE SET 
  mtv_plan_webhook.label = 'MTV Plan Webhook',
  mtv_plan_webhook.subsystem = 'Cluster',
  mtv_plan_webhook.type = 'Component',
  mtv_plan_webhook.description = 'Validating admission webhook for MTV Plan resources';

// --- ACM Addons for Virtualization ---
MERGE (mtv_addon:RHACMComponent {id: 'MTV_ADDON'})
ON CREATE SET 
  mtv_addon.label = 'MTV Addon',
  mtv_addon.subsystem = 'Cluster',
  mtv_addon.type = 'Addon',
  mtv_addon.description = 'ClusterManagementAddon for deploying MTV operator on spoke clusters';

MERGE (cnv_addon:RHACMComponent {id: 'CNV_ADDON'})
ON CREATE SET 
  cnv_addon.label = 'CNV Addon',
  cnv_addon.subsystem = 'Cluster',
  cnv_addon.type = 'Addon',
  cnv_addon.description = 'ClusterManagementAddon for deploying OpenShift Virtualization on spoke clusters';

// --- Fleet Virtualization UI ---
MERGE (fleet_virtualization:RHACMComponent {id: 'FLEET_VIRTUALIZATION'})
ON CREATE SET 
  fleet_virtualization.label = 'Fleet Virtualization',
  fleet_virtualization.subsystem = 'Console',
  fleet_virtualization.type = 'Component',
  fleet_virtualization.description = 'Multi-cluster VM management UI in ACM Console';

MERGE (vm_tree_view:RHACMComponent {id: 'VM_TREE_VIEW'})
ON CREATE SET 
  vm_tree_view.label = 'VM Tree View',
  vm_tree_view.subsystem = 'Console',
  vm_tree_view.type = 'Component',
  vm_tree_view.description = 'Hierarchical VM navigation across clusters in Console';

MERGE (vm_actions:RHACMComponent {id: 'VM_ACTIONS'})
ON CREATE SET 
  vm_actions.label = 'VM Actions',
  vm_actions.subsystem = 'Console',
  vm_actions.type = 'Component',
  vm_actions.description = 'VM lifecycle actions: Start, Stop, Restart, Pause, Unpause, Snapshot';

MERGE (vm_search_integration:RHACMComponent {id: 'VM_SEARCH_INTEGRATION'})
ON CREATE SET 
  vm_search_integration.label = 'VM Search Integration',
  vm_search_integration.subsystem = 'Search',
  vm_search_integration.type = 'Component',
  vm_search_integration.description = 'Search indexing for VirtualMachine resources across clusters';

// --- KubeVirt Console Plugin (kubevirt-ui) ---
MERGE (kubevirt_plugin:RHACMComponent {id: 'KUBEVIRT_PLUGIN'})
ON CREATE SET 
  kubevirt_plugin.label = 'KubeVirt Console Plugin',
  kubevirt_plugin.subsystem = 'Console',
  kubevirt_plugin.type = 'Component',
  kubevirt_plugin.description = 'OpenShift Console dynamic plugin for VM management UI';

// ============================================================================
// SECTION 5: FINE-GRAINED RBAC
// ============================================================================

// --- MultiClusterRoleAssignment Operator ---
MERGE (mcra_operator:RHACMComponent {id: 'MCRA_OPERATOR'})
ON CREATE SET 
  mcra_operator.label = 'MultiClusterRoleAssignment Operator',
  mcra_operator.subsystem = 'Cluster',
  mcra_operator.type = 'Operator',
  mcra_operator.description = 'Fine-Grained RBAC operator creating role bindings on managed clusters';

MERGE (mcra_crd:RHACMComponent {id: 'MCRA_CRD'})
ON CREATE SET 
  mcra_crd.label = 'MultiClusterRoleAssignment CRD',
  mcra_crd.subsystem = 'Cluster',
  mcra_crd.type = 'CRD',
  mcra_crd.description = 'API for assigning cluster roles to users/groups on managed clusters';

// --- ClusterPermission ---
MERGE (cluster_permission:RHACMComponent {id: 'CLUSTER_PERMISSION_CRD'})
ON CREATE SET 
  cluster_permission.label = 'ClusterPermission CRD',
  cluster_permission.subsystem = 'Cluster',
  cluster_permission.type = 'CRD',
  cluster_permission.description = 'API for creating role/clusterrole bindings on managed clusters';

// --- Fine-Grained RBAC Search Integration ---
MERGE (rbac_fg_search:RHACMComponent {id: 'RBAC_FINE_GRAINED_SEARCH'})
ON CREATE SET 
  rbac_fg_search.label = 'Fine-Grained RBAC Search Integration',
  rbac_fg_search.subsystem = 'Search',
  rbac_fg_search.type = 'Component',
  rbac_fg_search.description = 'RBAC-aware search results filtering based on MCRA permissions';

// --- KubeVirt Standard Roles ---
MERGE (kubevirt_roles:RHACMComponent {id: 'KUBEVIRT_STANDARD_ROLES'})
ON CREATE SET 
  kubevirt_roles.label = 'KubeVirt Standard Roles',
  kubevirt_roles.subsystem = 'Cluster',
  kubevirt_roles.type = 'Component',
  kubevirt_roles.description = 'Standard ClusterRoles: kubevirt.io:admin, kubevirt.io:edit, kubevirt.io:view';

// --- ACM Managed Roles ---
MERGE (acm_hub_roles:RHACMComponent {id: 'ACM_HUB_KUBEVIRT_ROLES'})
ON CREATE SET 
  acm_hub_roles.label = 'ACM Hub KubeVirt Roles',
  acm_hub_roles.subsystem = 'Cluster',
  acm_hub_roles.type = 'Component',
  acm_hub_roles.description = 'ACM-specific hub roles: kubevirt.io-acm-hub:admin/edit/view';

MERGE (acm_managed_roles:RHACMComponent {id: 'ACM_MANAGED_KUBEVIRT_ROLES'})
ON CREATE SET 
  acm_managed_roles.label = 'ACM Managed KubeVirt Roles',
  acm_managed_roles.subsystem = 'Cluster',
  acm_managed_roles.type = 'Component',
  acm_managed_roles.description = 'ACM-specific managed cluster roles: kubevirt.io-acm-managed:admin/edit/view';

// --- RBAC UI Components ---
MERGE (rbac_ui:RHACMComponent {id: 'RBAC_UI'})
ON CREATE SET 
  rbac_ui.label = 'RBAC UI',
  rbac_ui.subsystem = 'Console',
  rbac_ui.type = 'Component',
  rbac_ui.description = 'Access Control UI for managing MCRA and ClusterPermission';

MERGE (access_management_ui:RHACMComponent {id: 'ACCESS_MANAGEMENT_UI'})
ON CREATE SET 
  access_management_ui.label = 'Access Management UI',
  access_management_ui.subsystem = 'Console',
  access_management_ui.type = 'Component',
  access_management_ui.description = 'Console UI for role assignment and permission management';

// ============================================================================
// SECTION 6: ADDITIONAL COMPONENTS (Tekton, Backup, Monitoring)
// ============================================================================

// --- Tekton Integration ---
MERGE (kubevirt_tekton:RHACMComponent {id: 'KUBEVIRT_TEKTON_TASKS'})
ON CREATE SET 
  kubevirt_tekton.label = 'KubeVirt Tekton Tasks',
  kubevirt_tekton.subsystem = 'Cluster',
  kubevirt_tekton.type = 'Component',
  kubevirt_tekton.description = 'VM-specific tasks for Tekton Pipelines (create VM, disk operations)';

// --- Backup Integration ---
MERGE (kubevirt_velero:RHACMComponent {id: 'KUBEVIRT_VELERO_PLUGIN'})
ON CREATE SET 
  kubevirt_velero.label = 'KubeVirt Velero Plugin',
  kubevirt_velero.subsystem = 'Cluster',
  kubevirt_velero.type = 'Component',
  kubevirt_velero.description = 'Velero plugin for backup/restore of KubeVirt/CDI resources';

// --- Cluster API Provider ---
MERGE (capi_kubevirt:RHACMComponent {id: 'CLUSTER_API_PROVIDER_KUBEVIRT'})
ON CREATE SET 
  capi_kubevirt.label = 'Cluster API Provider KubeVirt',
  capi_kubevirt.subsystem = 'Cluster',
  capi_kubevirt.type = 'Component',
  capi_kubevirt.description = 'CAPI provider for provisioning clusters using KubeVirt VMs';

// ============================================================================
// SECTION 7: RELATIONSHIPS
// ============================================================================

// --- HCO manages CNV components ---
MATCH (hco:RHACMComponent {id: 'HCO_OPERATOR'})
MATCH (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
MERGE (hco)-[:MANAGES]->(kubevirt);

MATCH (hco:RHACMComponent {id: 'HCO_OPERATOR'})
MATCH (cdi:RHACMComponent {id: 'CDI_OPERATOR'})
MERGE (hco)-[:MANAGES]->(cdi);

MATCH (hco:RHACMComponent {id: 'HCO_OPERATOR'})
MATCH (ssp:RHACMComponent {id: 'SSP_OPERATOR'})
MERGE (hco)-[:MANAGES]->(ssp);

MATCH (hco:RHACMComponent {id: 'HCO_OPERATOR'})
MATCH (cnao:RHACMComponent {id: 'CNAO_OPERATOR'})
MERGE (hco)-[:MANAGES]->(cnao);

MATCH (hco:RHACMComponent {id: 'HCO_OPERATOR'})
MATCH (hostpath:RHACMComponent {id: 'HOSTPATH_PROVISIONER_OPERATOR'})
MERGE (hco)-[:MANAGES]->(hostpath);

MATCH (hco:RHACMComponent {id: 'HCO_OPERATOR'})
MATCH (nodemaint:RHACMComponent {id: 'NODE_MAINTENANCE_OPERATOR'})
MERGE (hco)-[:MANAGES]->(nodemaint);

// --- SSP deploys templates ---
MATCH (ssp:RHACMComponent {id: 'SSP_OPERATOR'})
MATCH (templates:RHACMComponent {id: 'COMMON_TEMPLATES'})
MERGE (ssp)-[:DEPLOYS]->(templates);

MATCH (ssp:RHACMComponent {id: 'SSP_OPERATOR'})
MATCH (instancetypes:RHACMComponent {id: 'COMMON_INSTANCETYPES'})
MERGE (ssp)-[:DEPLOYS]->(instancetypes);

MATCH (ssp:RHACMComponent {id: 'SSP_OPERATOR'})
MATCH (console_proxy:RHACMComponent {id: 'VM_CONSOLE_PROXY'})
MERGE (ssp)-[:DEPLOYS]->(console_proxy);

// --- CNAO deploys network components ---
MATCH (cnao:RHACMComponent {id: 'CNAO_OPERATOR'})
MATCH (macvtap:RHACMComponent {id: 'MACVTAP_CNI'})
MERGE (cnao)-[:DEPLOYS]->(macvtap);

MATCH (cnao:RHACMComponent {id: 'CNAO_OPERATOR'})
MATCH (bridge:RHACMComponent {id: 'LINUX_BRIDGE_CNI'})
MERGE (cnao)-[:DEPLOYS]->(bridge);

MATCH (cnao:RHACMComponent {id: 'CNAO_OPERATOR'})
MATCH (dns:RHACMComponent {id: 'KUBESECONDARYDNS'})
MERGE (cnao)-[:DEPLOYS]->(dns);

// --- CDI relationships ---
MATCH (cdi:RHACMComponent {id: 'CDI_OPERATOR'})
MATCH (cdi_ctrl:RHACMComponent {id: 'CDI_CONTROLLER'})
MERGE (cdi)-[:MANAGES]->(cdi_ctrl);

MATCH (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
MATCH (cdi:RHACMComponent {id: 'CDI_OPERATOR'})
MERGE (kubevirt)-[:INTEGRATES_WITH]->(cdi);

// --- MTV Operator manages controllers ---
MATCH (mtv:RHACMComponent {id: 'MTV_OPERATOR'})
MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MERGE (mtv)-[:MANAGES]->(forklift);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (plan:RHACMComponent {id: 'MTV_PLAN_CONTROLLER'})
MERGE (forklift)-[:CONTAINS]->(plan);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (migration:RHACMComponent {id: 'MTV_MIGRATION_CONTROLLER'})
MERGE (forklift)-[:CONTAINS]->(migration);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (provider:RHACMComponent {id: 'MTV_PROVIDER_CONTROLLER'})
MERGE (forklift)-[:CONTAINS]->(provider);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (netmap:RHACMComponent {id: 'MTV_NETWORK_MAP_CONTROLLER'})
MERGE (forklift)-[:CONTAINS]->(netmap);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (storagemap:RHACMComponent {id: 'MTV_STORAGE_MAP_CONTROLLER'})
MERGE (forklift)-[:CONTAINS]->(storagemap);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (hook:RHACMComponent {id: 'MTV_HOOK_CONTROLLER'})
MERGE (forklift)-[:CONTAINS]->(hook);

// --- MTV depends on KubeVirt ---
MATCH (mtv:RHACMComponent {id: 'MTV_OPERATOR'})
MATCH (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
MERGE (mtv)-[:DEPENDS_ON]->(kubevirt);

MATCH (mtv:RHACMComponent {id: 'MTV_OPERATOR'})
MATCH (cdi:RHACMComponent {id: 'CDI_OPERATOR'})
MERGE (mtv)-[:DEPENDS_ON]->(cdi);

// --- Volume populators ---
MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (ovirt:RHACMComponent {id: 'OVIRT_VOLUME_POPULATOR'})
MERGE (forklift)-[:USES]->(ovirt);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (openstack:RHACMComponent {id: 'OPENSTACK_VOLUME_POPULATOR'})
MERGE (forklift)-[:USES]->(openstack);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (vsphere:RHACMComponent {id: 'VSPHERE_XCOPY_VOLUME_POPULATOR'})
MERGE (forklift)-[:USES]->(vsphere);

MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (v2v:RHACMComponent {id: 'VIRT_V2V'})
MERGE (forklift)-[:USES]->(v2v);

// --- CCLM relationships ---
MATCH (cclm:RHACMComponent {id: 'CCLM'})
MATCH (cclm_op:RHACMComponent {id: 'KUBEVIRT_MIGRATION_OPERATOR'})
MERGE (cclm)-[:USES]->(cclm_op);

MATCH (cclm_op:RHACMComponent {id: 'KUBEVIRT_MIGRATION_OPERATOR'})
MATCH (cclm_ctrl:RHACMComponent {id: 'KUBEVIRT_MIGRATION_CONTROLLER'})
MERGE (cclm_op)-[:MANAGES]->(cclm_ctrl);

MATCH (cclm:RHACMComponent {id: 'CCLM'})
MATCH (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
MERGE (cclm)-[:DEPENDS_ON]->(kubevirt);

// --- ACM MTV Integrations ---
MATCH (mtv_int:RHACMComponent {id: 'MTV_INTEGRATIONS'})
MATCH (provider_mgr:RHACMComponent {id: 'PROVIDER_MANAGER_CONTROLLER'})
MERGE (mtv_int)-[:CONTAINS]->(provider_mgr);

MATCH (mtv_int:RHACMComponent {id: 'MTV_INTEGRATIONS'})
MATCH (webhook:RHACMComponent {id: 'MTV_PLAN_WEBHOOK'})
MERGE (mtv_int)-[:CONTAINS]->(webhook);

MATCH (mtv_int:RHACMComponent {id: 'MTV_INTEGRATIONS'})
MATCH (mtv_addon:RHACMComponent {id: 'MTV_ADDON'})
MERGE (mtv_int)-[:DEPLOYS]->(mtv_addon);

MATCH (mtv_int:RHACMComponent {id: 'MTV_INTEGRATIONS'})
MATCH (cnv_addon:RHACMComponent {id: 'CNV_ADDON'})
MERGE (mtv_int)-[:DEPLOYS]->(cnv_addon);

// --- Addons manage operators on spokes ---
MATCH (mtv_addon:RHACMComponent {id: 'MTV_ADDON'})
MATCH (mtv:RHACMComponent {id: 'MTV_OPERATOR'})
MERGE (mtv_addon)-[:MANAGES]->(mtv);

MATCH (cnv_addon:RHACMComponent {id: 'CNV_ADDON'})
MATCH (hco:RHACMComponent {id: 'HCO_OPERATOR'})
MERGE (cnv_addon)-[:MANAGES]->(hco);

// --- Fleet Virtualization relationships ---
MATCH (fleet:RHACMComponent {id: 'FLEET_VIRTUALIZATION'})
MATCH (search:RHACMComponent {label: 'Search & Discovery'})
MERGE (fleet)-[:USES]->(search);

MATCH (console:RHACMComponent {label: 'Web Console'})
MATCH (fleet:RHACMComponent {id: 'FLEET_VIRTUALIZATION'})
MERGE (console)-[:PROVIDES_UI_FOR]->(fleet);

MATCH (fleet:RHACMComponent {id: 'FLEET_VIRTUALIZATION'})
MATCH (tree:RHACMComponent {id: 'VM_TREE_VIEW'})
MERGE (fleet)-[:CONTAINS]->(tree);

MATCH (fleet:RHACMComponent {id: 'FLEET_VIRTUALIZATION'})
MATCH (actions:RHACMComponent {id: 'VM_ACTIONS'})
MERGE (fleet)-[:CONTAINS]->(actions);

MATCH (fleet:RHACMComponent {id: 'FLEET_VIRTUALIZATION'})
MATCH (vm_search:RHACMComponent {id: 'VM_SEARCH_INTEGRATION'})
MERGE (fleet)-[:USES]->(vm_search);

// --- Fine-Grained RBAC relationships ---
MATCH (mcra:RHACMComponent {id: 'MCRA_OPERATOR'})
MATCH (mcra_crd:RHACMComponent {id: 'MCRA_CRD'})
MERGE (mcra)-[:MANAGES]->(mcra_crd);

MATCH (mcra:RHACMComponent {id: 'MCRA_OPERATOR'})
MATCH (mc:RHACMComponent {label: 'Managed Clusters'})
MERGE (mcra)-[:MANAGES]->(mc);

MATCH (rbac_search:RHACMComponent {id: 'RBAC_FINE_GRAINED_SEARCH'})
MATCH (mcra:RHACMComponent {id: 'MCRA_OPERATOR'})
MERGE (rbac_search)-[:DEPENDS_ON]->(mcra);

MATCH (fleet:RHACMComponent {id: 'FLEET_VIRTUALIZATION'})
MATCH (mcra:RHACMComponent {id: 'MCRA_OPERATOR'})
MERGE (fleet)-[:INTEGRATES_WITH]->(mcra);

MATCH (rbac_ui:RHACMComponent {id: 'RBAC_UI'})
MATCH (mcra:RHACMComponent {id: 'MCRA_OPERATOR'})
MERGE (rbac_ui)-[:PROVIDES_UI_FOR]->(mcra);

MATCH (rbac_ui:RHACMComponent {id: 'RBAC_UI'})
MATCH (cluster_perm:RHACMComponent {id: 'CLUSTER_PERMISSION_CRD'})
MERGE (rbac_ui)-[:PROVIDES_UI_FOR]->(cluster_perm);

MATCH (access_ui:RHACMComponent {id: 'ACCESS_MANAGEMENT_UI'})
MATCH (rbac_ui:RHACMComponent {id: 'RBAC_UI'})
MERGE (access_ui)-[:CONTAINS]->(rbac_ui);

// --- KubeVirt roles ---
MATCH (mcra:RHACMComponent {id: 'MCRA_OPERATOR'})
MATCH (kv_roles:RHACMComponent {id: 'KUBEVIRT_STANDARD_ROLES'})
MERGE (mcra)-[:USES]->(kv_roles);

MATCH (mcra:RHACMComponent {id: 'MCRA_OPERATOR'})
MATCH (hub_roles:RHACMComponent {id: 'ACM_HUB_KUBEVIRT_ROLES'})
MERGE (mcra)-[:USES]->(hub_roles);

MATCH (mcra:RHACMComponent {id: 'MCRA_OPERATOR'})
MATCH (managed_roles:RHACMComponent {id: 'ACM_MANAGED_KUBEVIRT_ROLES'})
MERGE (mcra)-[:USES]->(managed_roles);

// --- Console plugin relationships ---
MATCH (console:RHACMComponent {label: 'Web Console'})
MATCH (kv_plugin:RHACMComponent {id: 'KUBEVIRT_PLUGIN'})
MERGE (console)-[:USES]->(kv_plugin);

MATCH (console:RHACMComponent {label: 'Web Console'})
MATCH (forklift_console:RHACMComponent {id: 'FORKLIFT_CONSOLE_PLUGIN'})
MERGE (console)-[:USES]->(forklift_console);

// --- API relationships (added 2026-02-02) ---
// KubeVirt Operator provides KubeVirt API (VM, VMI, DataVolume CRDs)
MATCH (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
MATCH (api:RHACMComponent {id: 'KUBEVIRT_API'})
MERGE (kubevirt)-[:PROVIDES_API]->(api);

// Forklift Controller provides Forklift API (Migration, Plan, Provider CRDs)
MATCH (forklift:RHACMComponent {id: 'FORKLIFT_CONTROLLER'})
MATCH (api:RHACMComponent {id: 'FORKLIFT_API'})
MERGE (forklift)-[:PROVIDES_API]->(api);

// --- ContainerDisks relationship ---
// CDI Operator provides container disk images
MATCH (cdi:RHACMComponent {id: 'CDI_OPERATOR'})
MATCH (disks:RHACMComponent {id: 'CONTAINERDISKS'})
MERGE (cdi)-[:PROVIDES]->(disks);

// --- Provider Server relationships ---
// Provider Controller uses OVA Provider Server for OVA file imports
MATCH (provider:RHACMComponent {id: 'MTV_PROVIDER_CONTROLLER'})
MATCH (ova:RHACMComponent {id: 'OVA_PROVIDER_SERVER'})
MERGE (provider)-[:USES]->(ova);

// Provider Controller uses Hyper-V Provider Server for Hyper-V migrations
MATCH (provider:RHACMComponent {id: 'MTV_PROVIDER_CONTROLLER'})
MATCH (hyperv:RHACMComponent {id: 'HYPERV_PROVIDER_SERVER'})
MERGE (provider)-[:USES]->(hyperv);

// --- Migration Planner integration ---
// MTV Integrations integrates with Migration Planner for VMware assessment
MATCH (mtv_int:RHACMComponent {id: 'MTV_INTEGRATIONS'})
MATCH (planner:RHACMComponent {id: 'MIGRATION_PLANNER'})
MERGE (mtv_int)-[:INTEGRATES_WITH]->(planner);

// --- Tekton Tasks relationships ---
// SSP Operator deploys KubeVirt Tekton Tasks
MATCH (ssp:RHACMComponent {id: 'SSP_OPERATOR'})
MATCH (tekton:RHACMComponent {id: 'KUBEVIRT_TEKTON_TASKS'})
MERGE (ssp)-[:DEPLOYS]->(tekton);

// Tekton Tasks integrate with KubeVirt for VM automation
MATCH (tekton:RHACMComponent {id: 'KUBEVIRT_TEKTON_TASKS'})
MATCH (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
MERGE (tekton)-[:INTEGRATES_WITH]->(kubevirt);

// --- Velero Plugin relationships ---
// OADP Operator uses KubeVirt Velero Plugin for VM backup
MATCH (oadp:RHACMComponent {id: 'OADP_OPERATOR'})
MATCH (velero_plugin:RHACMComponent {id: 'KUBEVIRT_VELERO_PLUGIN'})
MERGE (oadp)-[:USES]->(velero_plugin);

// Velero Plugin integrates with KubeVirt for backup/restore
MATCH (velero_plugin:RHACMComponent {id: 'KUBEVIRT_VELERO_PLUGIN'})
MATCH (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
MERGE (velero_plugin)-[:INTEGRATES_WITH]->(kubevirt);

// --- CAPI KubeVirt relationships ---
// CAPI Provider Integration contains Cluster API Provider KubeVirt
MATCH (capi:RHACMComponent {id: 'CAPI_PROVIDER_INTEGRATION'})
MATCH (capi_kv:RHACMComponent {id: 'CLUSTER_API_PROVIDER_KUBEVIRT'})
MERGE (capi)-[:CONTAINS]->(capi_kv);

// CAPI KubeVirt uses KubeVirt to provision VMs as cluster nodes
MATCH (capi_kv:RHACMComponent {id: 'CLUSTER_API_PROVIDER_KUBEVIRT'})
MATCH (kubevirt:RHACMComponent {id: 'KUBEVIRT_OPERATOR'})
MERGE (capi_kv)-[:USES]->(kubevirt);

// ============================================================================
// END OF SCRIPT
// ============================================================================
