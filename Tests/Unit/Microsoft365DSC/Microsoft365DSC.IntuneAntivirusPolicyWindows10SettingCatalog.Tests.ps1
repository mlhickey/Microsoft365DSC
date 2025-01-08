[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'IntuneAntivirusPolicyWindows10SettingCatalog' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-IntuneDeviceConfigurationPolicy -MockWith {
            }
            Mock -CommandName New-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }
            }
            Mock -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Get-IntuneSettingCatalogPolicySetting -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                return @{
                    Id                   = 0
                    SettingDefinitions   = @(
                        @{
                            Id = 'device_vendor_msft_policy_config_defender_allowarchivescanning'
                            Name = 'AllowArchiveScanning'
                            OffsetUri = '/Config/Defender/AllowArchiveScanning'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                            }
                        }
                    )
                    SettingInstance      = @{
                        SettingDefinitionId              = 'device_vendor_msft_policy_config_defender_allowarchivescanning'
                        SettingInstanceTemplateReference = @{
                            SettingInstanceTemplateId = '7c5c9cde-f74d-4d11-904f-de4c27f72d89'
                            AdditionalProperties      = $null
                        }
                        AdditionalProperties             = @{
                            '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                            choiceSettingValue = @{
                                value                         = 'device_vendor_msft_policy_config_defender_allowarchivescanning_1'
                                settingValueTemplateReference = @{
                                    settingValueTemplateId = '9ead75d4-6f30-4bc5-8cc5-ab0f999d79f0'
                                    useTemplateDefault     = $false
                                }
                                children                   = @()
                            }
                        }
                    }
                }
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id                = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    Description       = 'My Test Description'
                    Name              = 'My Test'
                    TemplateReference = @{
                        TemplateId     = 'd948ff9b-99cb-4ee0-8012-1fbc09685377_1'
                        TemplateFamily = 'endpointSecurityAntivirus'
                    }
                }
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                return @(
                    @{
                        Id       = '12345-12345-12345-12345-12345'
                        Source   = 'direct'
                        SourceId = '12345-12345-12345-12345-12345'
                        Target   = @{
                            DeviceAndAppManagementAssignmentFilterId   = '12345-12345-12345-12345-12345'
                            DeviceAndAppManagementAssignmentFilterType = 'none'
                            AdditionalProperties                       = @(
                                @{
                                    '@odata.type' = '#microsoft.graph.exclusionGroupAssignmentTarget'
                                    groupId       = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                                }
                            )
                        }
                    }
                )
            }

            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            Mock -CommandName Write-Warning -MockWith {
            }

            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the instance doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    allowarchivescanning = '1'
                    Assignments          = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType                                   = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            DeviceAndAppManagementAssignmentFilterType = 'none'
                            GroupId                                    = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential           = $Credential
                    Description          = 'My Test Description'
                    DisplayName          = 'My Test'
                    Ensure               = 'Present'
                    Identity             = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    templateId           = 'd948ff9b-99cb-4ee0-8012-1fbc09685377_1'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    allowarchivescanning = '0' # Drift
                    Assignments          = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType                                   = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            DeviceAndAppManagementAssignmentFilterType = 'none'
                            GroupId                                    = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential           = $Credential
                    Description          = 'My Test Description'
                    DisplayName          = 'My Test'
                    Ensure               = 'Present'
                    templateId           = 'd948ff9b-99cb-4ee0-8012-1fbc09685377_1'
                    Identity             = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-IntuneDeviceConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    allowarchivescanning = '1'
                    Assignments          = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType                                   = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            DeviceAndAppManagementAssignmentFilterType = 'none'
                            GroupId                                    = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential           = $Credential
                    Description          = 'My Test Description'
                    DisplayName          = 'My Test'
                    Ensure               = 'Present'
                    templateId           = 'd948ff9b-99cb-4ee0-8012-1fbc09685377_1'
                    Identity             = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the instance exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    allowarchivescanning = '0'
                    Assignments          = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType                                   = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            DeviceAndAppManagementAssignmentFilterType = 'none'
                            GroupId                                    = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential           = $Credential
                    Description          = 'My Test Description'
                    DisplayName          = 'My Test'
                    Ensure               = 'Absent'
                    templateId           = 'd948ff9b-99cb-4ee0-8012-1fbc09685377_1'
                    Identity             = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
