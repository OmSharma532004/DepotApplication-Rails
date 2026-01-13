class Admin::CategoriesController < ApplicationController
    before_action :set_category, on: %i[ products ]
    def index
        @categories = Category.all
    end

    def products
        @products = @category.all_products
    end

    private

    def set_category
        @category = Category.find_by(id: params[:id])
    end
end