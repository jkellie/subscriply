module SubscriptionTotalRecorder
  class << self

    def run
      organizations.each do |organization|
        calculate_totals(organization)
        calculate_plan_totals(organization)
      end
    end

    private

    def calculate_totals(organization)
      count = organization.subscriptions.active.count
      
      SubscriptionTotalRecord.create({
        organization_id: organization.id,
        plan_id: nil,
        total: count,
        created_at: Time.zone.now.to_date
      })
    end

    def calculate_plan_totals(organization)
      organization.plans.each do |plan|
        count = organization.subscriptions.active.where(plan: plan).count

        SubscriptionTotalRecord.create({
          organization_id: organization.id,
          plan_id: plan.id,
          total: count,
          created_at: Time.zone.now.to_date
        })
      end
    end

    def organizations
      Organization.all
    end
  end
  
end