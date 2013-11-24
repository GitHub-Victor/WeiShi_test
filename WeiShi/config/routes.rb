# -*- encoding : utf-8 -*-
DandelionCampus::Application.routes.draw do
  root :to => 'home#index'
  mount Ckeditor::Engine => '/ckeditor'
  mount ChinaCity::Engine => '/china_city'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end