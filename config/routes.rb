Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'shogi#index'
  get 'shogi/index'
  get 'shogi/list'
  get ':id', to: 'shogi#view', id: /\w+\.log/, as: 'hogee'

end
