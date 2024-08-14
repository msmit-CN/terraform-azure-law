package main

import (
	"context"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/operationalinsights/armoperationalinsights"
	"github.com/cloudnationhq/terraform-azure-law/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type LogAnalyticsDetails struct {
	ResourceGroupName string
	Name              string
}

type ClientSetup struct {
	SubscriptionID     string
	LogAnalyticsClient *armoperationalinsights.WorkspacesClient
}

func (details *LogAnalyticsDetails) GetWorkspace(
	t *testing.T,
	client *armoperationalinsights.WorkspacesClient,
) *armoperationalinsights.Workspace {
	resp, err := client.Get(context.Background(), details.ResourceGroupName, details.Name, nil)
	require.NoError(t, err, "Failed to get log analytics workspace")
	return &resp.Workspace
}

func (setup *ClientSetup) InitializeWorkspaceClient(t *testing.T, cred *azidentity.DefaultAzureCredential) {
	var err error
	setup.LogAnalyticsClient, err = armoperationalinsights.NewWorkspacesClient(setup.SubscriptionID, cred, nil)
	require.NoError(t, err, "Failed to create log analytics client")
}

func TestWorkspace(t *testing.T) {
	t.Run("VerifyWorkspace", func(t *testing.T) {
		t.Parallel()

		cred, err := azidentity.NewDefaultAzureCredential(nil)
		require.NoError(t, err, "Failed to create credential")

		tfOpts := shared.GetTerraformOptions("../examples/complete")
		defer shared.Cleanup(t, tfOpts)
		terraform.InitAndApply(t, tfOpts)

		workspaceMap := terraform.OutputMap(t, tfOpts, "workspace")
		subscriptionID := terraform.Output(t, tfOpts, "subscription_id")

		workspaceDetails := &LogAnalyticsDetails{
			ResourceGroupName: workspaceMap["resource_group_name"],
			Name:              workspaceMap["name"],
		}

		ClientSetup := &ClientSetup{SubscriptionID: subscriptionID}
		ClientSetup.InitializeWorkspaceClient(t, cred)
		workspace := workspaceDetails.GetWorkspace(t, ClientSetup.LogAnalyticsClient)

		t.Run("VerifyWorkspaceName", func(t *testing.T) {
			verifyWorkspace(t, workspaceDetails, workspace)
		})
	})
}

func verifyWorkspace(t *testing.T, details *LogAnalyticsDetails, workspace *armoperationalinsights.Workspace) {
	t.Helper()

	require.Equal(
		t,
		details.Name,
		*workspace.Name,
		"Workspace name does not match",
	)

	require.Equal(
		t,
		"Succeeded",
		string(*workspace.Properties.ProvisioningState),
		"Workspace provisioning state is not succeeded",
	)

	require.True(
		t,
		strings.HasPrefix(details.Name, "log"),
		"Workspace name does not start with the right abbreviation",
	)
}
