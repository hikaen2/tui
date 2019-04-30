Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'shogi#dir'
  get ':id', to: 'shogi#view', id: /\w+\.log/, as: 'shogi_view'
  get 'partial/:id/:moves', to: 'shogi#board', id: /\w+\.log/, moves: /\d+/

end
