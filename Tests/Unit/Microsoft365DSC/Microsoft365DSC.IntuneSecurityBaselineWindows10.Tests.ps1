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
    -DscResource "IntuneSecurityBaselineWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id = '12345-12345-12345-12345-12345'
                }
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id              = '12345-12345-12345-12345-12345'
                    Description     = 'My Test'
                    Name            = 'My Test'
                    RoleScopeTagIds = @("FakeStringValue")
                    TemplateReference = @{
                       TemplateId = '66df8dce-0166-4b82-92f7-1f74e3ca17a3_1'
                    }
                }                
            }

            Mock -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Update-IntuneDeviceConfigurationPolicy -MockWith {
            }

            Mock -CommandName Get-IntuneSettingCatalogPolicySetting -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                return @(
                    @{
                        Id = '0'
                        SettingDefinitions = @(
                            @{
                                Id = 'device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel'
                                Name = 'Pol_MSS_DisableIPSourceRoutingIPv6'
                                OffsetUri = '/Config/MSSLegacy/IPv6SourceRoutingProtectionLevel'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                    options=@(
                                        @{
                                            name ='Enabled'
                                            itemId = 'device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel_1'                                                                                        
                                        }
                                    )
                                }
                            },
                            @{
                                Id = 'device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel_disableipsourceroutingipv6'
                                Name = 'DisableIPSourceRoutingIPv6'
                                OffsetUri = '/Config/MSSLegacy/IPv6SourceRoutingProtectionLevel'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                    options=@(
                                        @{
                                            name ='No additional protection, source routed packets are allowed'
                                            itemId = 'device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel_disableipsourceroutingipv6_0'
                                            dependentOn = @(
                                                @{
                                                    dependentOn = 'device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel_1'
                                                    parentSettingId = 'device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel'
                                                }
                                            )                                                                                        
                                        }
                                    )
                                }
                            }
                        )
                        SettingInstance = @{
                            SettingDefinitionId = 'device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'd26001a0-5e2d-4f45-94f6-a8fb15b016d8'
                            }
                            AdditionalProperties = @{
                               '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                choiceSettingValue = @{
                                    children = @(
                                        @{
                                            SettingDefinitionId = 'device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel_disableipsourceroutingipv6'                                                                                       
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                            choiceSettingValue = @{
                                                children = @()
                                                value = "device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel_disableipsourceroutingipv6_0"
                                            }
                                        }
                                    )
                                    value = "device_vendor_msft_policy_config_msslegacy_ipv6sourceroutingprotectionlevel_1"
                                }
                            }
                        }                         
                    }
                    @{
                        Id = '1'
                        SettingDefinitions = @(
                            @{
                                Id = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths'
                                Name = 'Pol_HardenedPaths'
                                OffsetUri = '/Config/Connectivity/HardenedUNCPaths'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                    options = @(
                                        @{
                                            name ='Enabled'
                                            itemId = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_1'                                                                                                                                 
                                        }
                                    )
                                }
                            },
                            @{
                                Id = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths'
                                Name = 'Pol_HardenedPaths'
                                OffsetUri = '/Config/Connectivity/HardenedUNCPaths'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionDefinition'
                                    maximumCount = 600
                                    minimumCount = 1
                                    childIds = @(
                                        'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths_key',
                                        'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths_value'         
                                    )
                                    dependentOn = @(
                                        @{
                                            dependentOn = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_1'
                                            parentSettingId = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths'
                                        }
                                    )
                                }
                            },
                            @{
                                Id = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths_value'
                                Name = 'Pol_HardenedPaths'
                                OffsetUri = '/Config/Connectivity/HardenedUNCPaths'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingDefinition'
                                    dependentOn = @(
                                        @{
                                            dependentOn = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths'
                                            parentSettingId = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths'
                                        }
                                    )                                                             
                                }                                                                
                            },
                            @{
                                Id = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths_key'
                                Name = 'Pol_HardenedPaths'
                                OffsetUri = '/Config/Connectivity/HardenedUNCPaths'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingDefinition'
                                    dependentOn = @(
                                        @{
                                            dependentOn = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths'
                                            parentSettingId = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths'
                                        }
                                    )                                                             
                                }                                                                
                            }
                        )
                        SettingInstance = @{
                            SettingDefinitionId = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'd26001a0-5e2d-4f45-94f6-a8fb15b016d8'
                            }
                            AdditionalProperties = @{
                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                 choiceSettingValue = @{
                                    children = @(
                                        @{
                                            SettingDefinitionId = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths'                                                                                       
                                            '@odata.type' = "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
                                            groupSettingCollectionValue = @{
                                                children = @(
                                                    @{
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths_value'
                                                        simpleSettingValue = @{
                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                            value = 'RequireMutualAuthentication=1,RequireIntegrity=1'
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_connectivity_hardeneduncpaths_pol_hardenedpaths_key'
                                                        simpleSettingValue = @{
                                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                                                            value = '\\*\SYSVOL'
                                                        }                                                        
                                                    }
                                                 )                                                 
                                             }
                                        }
                                    )
                                    value = "device_vendor_msft_policy_config_connectivity_hardeneduncpaths_1"
                                }
                            }
                        }
                    }                    
                    @{
                        Id = '2'
                        SettingDefinitions = @(
                            @{
                                Id = 'user_vendor_msft_policy_config_experience_allowwindowsspotlight'
                                Name = 'AllowWindowsSpotlight'
                                OffsetUri = '/Config/Experience/AllowWindowsSpotlight'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                    options=@(
                                        @{
                                            name ='Allowed.'
                                            itemId = 'user_vendor_msft_policy_config_experience_allowwindowsspotlight_1'                                            
                                        }
                                    )
                                }
                            }
                        )
                        SettingInstance = @{
                            SettingDefinitionId = 'user_vendor_msft_policy_config_experience_allowwindowsspotlight'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'bb79e6fc-a957-476b-b8a1-0a7b1ac81c6a'
                            }
                            AdditionalProperties = @{
                               '@odata.type' = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                choiceSettingValue = @{
                                    children = @()
                                    value = "user_vendor_msft_policy_config_experience_allowwindowsspotlight_1"
                                }
                            }
                        }                         
                    }
                    @{
                        Id = '3'
                        SettingDefinitions = @(
                            @{
                                Id = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                Name = 'AttackSurfaceReductionRules'
                                OffsetUri = '/Config/Defender/AttackSurfaceReductionRules'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionDefinition'
                                    maximumCount = 1
                                    minimumCount = 0
                                    childIds = @(
                                        'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts'         
                                    )                            

                                }
                            },
                            @{
                                Id = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts'
                                Name = 'BlockExecutionOfPotentiallyObfuscatedScripts'
                                OffsetUri = '/Config/Defender/AttackSurfaceReductionRules'
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition'
                                    options=@(
                                        @{
                                            name ='Block'
                                            itemId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts_block'
                                            dependentOn = @(
                                                @{
                                                    dependentOn = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                                    parentSettingId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                                                }
                                            )                                            
                                        }
                                    )
                                }
                            }
                        )
                        SettingInstance = @{
                            SettingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = '3d6107c2-c307-4399-8070-6542f1760309'
                            }
                            AdditionalProperties = @{
                                SettingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'                                                                                       
                                '@odata.type' = "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
                                groupSettingCollectionValue = @{
                                    children = @(
                                        @{
                                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                            settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts'
                                            choiceSettingValue = @{
                                                children = @()
                                                value = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts_block'
                                            }
                                        }                                                    
                                    )                                                 
                                }
                            }                                    
                        }
                    }
                )
            }
            
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyAssignment -MockWith {
                return @(@{
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
                })
            }

        }

        # Test contexts
        Context -Name "The IntuneSecurityBaselineWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    deviceSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10 -Property @{
                        Pol_MSS_DisableIPSourceRoutingIPv6 = '1'
                        DisableIPSourceRoutingIPv6 = '0'                        
                        HardenedUNCPaths_Pol_HardenedPaths = '1'
                        BlockExecutionOfPotentiallyObfuscatedScripts = 'block'
                        pol_hardenedpaths = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths -Property @{
                                value = "RequireMutualAuthentication=1,RequireIntegrity=1"
                                key = "\\*\SYSVOL"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    Id = "12345-12345-12345-12345-12345"
                    DisplayName = "My Test"                    
                    RoleScopeTagIds = @("FakeStringValue")
                    userSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10 -Property @{
                        AllowWindowsSpotlight = '1'                   
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneSecurityBaselineWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    deviceSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10 -Property @{
                        Pol_MSS_DisableIPSourceRoutingIPv6 = '1'
                        DisableIPSourceRoutingIPv6 = '0'                        
                        HardenedUNCPaths_Pol_HardenedPaths = '1'
                        BlockExecutionOfPotentiallyObfuscatedScripts = 'block'
                        pol_hardenedpaths = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths -Property @{
                                value = "RequireMutualAuthentication=1,RequireIntegrity=1"
                                key = "\\*\SYSVOL"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    Id = "12345-12345-12345-12345-12345"
                    DisplayName = "My Test"                    
                    RoleScopeTagIds = @("FakeStringValue")
                    userSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10 -Property @{
                        AllowWindowsSpotlight = '1'                   
                    } -ClientOnly)
                    Ensure = "Absent"
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "The IntuneSecurityBaselineWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    deviceSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10 -Property @{
                        Pol_MSS_DisableIPSourceRoutingIPv6 = '1'
                        DisableIPSourceRoutingIPv6 = '0'                        
                        HardenedUNCPaths_Pol_HardenedPaths = '1'
                        BlockExecutionOfPotentiallyObfuscatedScripts = 'block'
                        pol_hardenedpaths = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths -Property @{
                                value = "RequireMutualAuthentication=1,RequireIntegrity=1"
                                key = "\\*\SYSVOL"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    Id = "12345-12345-12345-12345-12345"
                    DisplayName = "My Test"                    
                    RoleScopeTagIds = @("FakeStringValue")
                    userSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10 -Property @{
                        AllowWindowsSpotlight = '1'                   
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneSecurityBaselineWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            DataType = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "My Test"
                    deviceSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10 -Property @{
                        Pol_MSS_DisableIPSourceRoutingIPv6 = '1'
                        DisableIPSourceRoutingIPv6 = '0'                        
                        HardenedUNCPaths_Pol_HardenedPaths = '1'
                        BlockExecutionOfPotentiallyObfuscatedScripts = 'block'
                        pol_hardenedpaths = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths -Property @{
                                value = "RequireMutualAuthentication=1,RequireIntegrity=1"
                                key = "\\*\SYSVOL"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    Id = "12345-12345-12345-12345-12345"
                    DisplayName = "My Test"                    
                    RoleScopeTagIds = @("FakeStringValue")
                    userSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10 -Property @{
                        AllowWindowsSpotlight = '0' #drift                 
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-IntuneDeviceConfigurationPolicy -Exactly 1
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
