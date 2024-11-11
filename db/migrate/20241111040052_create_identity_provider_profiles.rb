# 20241111040052_create_identity_provider_profiles.rb
class CreateIdentityProviderProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :identity_provider_profiles, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :provider_name
      t.boolean :verified, default: false
      t.string :email
      t.string :unverified_email
      t.boolean :email_verified
      t.string :given_name, default: ''
      t.string :family_name, default: ''
      t.string :display_name
      t.string :image_url
      t.timestamp :confirmation_sent_at
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :identity_provider_profiles, %i[user_id provider_name], unique: true, if_not_exists: true
  end
end
