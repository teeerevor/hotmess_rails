HotmessRails::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'songs#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'short_lists/:email' => 'short_lists#show', :email => /.*/
  post 'short_lists/:email' => 'short_lists#update', :email => /.*/

  get 'songs' => 'songs#index'
  get '/:email' => 'short_lists#show', :email => /.*/

  mount MagicLamp::Genie, at: "/magic_lamp" if defined?(MagicLamp)
end
