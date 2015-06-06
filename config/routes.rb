Rails.application.routes.draw do
  resources :groups

	get "/contacts/upload" => "contacts#upload_page", as: "contacts_upload_page"
	get "/conversations/:contact_id/" => "messages#conversation", as: "conversation"
	post "/contacts/delete_multiple" => "contacts#delete_multiple", as: "delete_multiple_contacts"
	post "/upload_contacts" => "contacts#bulk_upload", :as => "upload_contacts", via: [:post]
	post "/add_to_class" => "contacts#add_to_group", :as => "add_to_group", via: [:post]
	
  resources :messages

  resources :categories

  resources :contacts

  resources :accounts

  root to: 'visitors#index'
  devise_for :users
end
