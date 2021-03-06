class AddRatingsAttributeToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :lease_rent_abatement_rating, :string
    add_column :properties, :lease_percentage_rent_exclusions_rating, :string
    add_column :properties, :taxes_and_fees_restate_rating, :string
    add_column :properties, :taxes_and_fees_assessments_rating, :string
    add_column :properties, :taxes_and_fees_separate_tax_parcel_rating, :string
    add_column :properties, :taxes_and_fees_landlord_contesting_rating, :string
    add_column :properties, :taxes_and_fees_tenant_contesting_rating, :string
    add_column :properties, :taxes_and_fees_easements_rating, :string
    add_column :properties, :site_preparation_env_obligations_rating, :string
    add_column :properties, :site_preparation_env_termination_rights_rating, :string
    add_column :properties, :site_preparation_env_remediation_rating, :string
    add_column :properties, :site_preparation_env_permits_and_licenses_rating, :string
    add_column :properties, :construction_rating, :string
    add_column :properties, :construction_deadline_rating, :string
    add_column :properties, :construction_liens_rating, :string
    add_column :properties, :construction_approval_of_plans_and_specs_rating, :string
    add_column :properties, :use_clause_rating, :string
    add_column :properties, :use_exclusive_clause_rating, :string
    add_column :properties, :premises_tenant_rights_rating, :string
    add_column :properties, :premises_waste_ratingpremises_initial_opening_rating, :string
    add_column :properties, :premises_recapture_clause_rating, :string
    add_column :properties, :premises_demolition_rating, :string
    add_column :properties, :premises_tenants_equipment_defined_rating, :string
    add_column :properties, :premises_ownership_and_removal_rating, :string
    add_column :properties, :premises_repairs_rating, :string
    add_column :properties, :premises_compliance_with_laws_rating, :string
    add_column :properties, :premises_surrender_rating, :string
    add_column :properties, :premises_inspection_rating, :string
    add_column :properties, :premises_insurance_rating, :string
    add_column :properties, :premises_destruction_rating, :string
    add_column :properties, :premises_total_taking_rating, :string
    add_column :properties, :premises_partial_taking_rating, :string
    add_column :properties, :premises_signs_rating, :string
    add_column :properties, :premises_utilities_rating, :string
    add_column :properties, :transfer_assignment_and_subletting_rating, :string
    add_column :properties, :transfer_leasehold_mortgage_rating, :string
    add_column :properties, :transfer_subordination_rating, :string
    add_column :properties, :transfer_estoppel_certificate_rating, :string
    add_column :properties, :remedies_rent_defaults_rating, :string
    add_column :properties, :remedies_landlord_rating, :string
    add_column :properties, :remedies_mitigation_rating, :string
    add_column :properties, :remedies_dispute_resolution_rating, :string
    add_column :properties, :remedies_landlord_exoneration_rating, :string
    add_column :properties, :remedies_exculpation_rating, :string
    add_column :properties, :misc_notices_rating, :string
    add_column :properties, :misc_obligation_rating, :string
  end
end
