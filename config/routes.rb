Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'shogi/index'
  get 'shogi/list'
  get 'shogi/view/:id', to: 'shogi#guhaa'

end
