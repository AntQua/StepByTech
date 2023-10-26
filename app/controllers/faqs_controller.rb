class FaqsController < ApplicationController
  before_action :set_faq, only: [:show, :edit, :update, :destroy]

  def index
    @faqs = Faq.all
  end

  def show
  end

  def new
    @faq = Faq.new
  end

  def create
    @faq = Faq.new(faq_params)
    @faq.save

    redirect_to faq_path(@faq)
  end

  def edit
  end

  def update
    @faq = Faq.new(faq_params)

    redirect_to faq_path(@faq)
  end

  def destroy
    @faq.destroy

    redirect_to faq_path, status: :see_other
  end

  private
  def faq_params
    params.require(:faq).permit(:title, :content)
  end

  def set_faq
    @faq = Faq.find(params[:id])
  end
end
