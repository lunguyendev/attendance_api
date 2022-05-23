class AddApproveByToSubject < ActiveRecord::Migration[6.0]
  def change
    add_column :subjects, :approve_by, :string
  end
end
