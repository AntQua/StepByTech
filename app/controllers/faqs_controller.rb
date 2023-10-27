class FaqsController < ApplicationController
  before_action :set_faq, only: [:show, :edit, :update, :destroy]

  before_action :authorize_faq, except: [:index]

  layout "dashboard", except: [:general]

  def index
    @faqs = Faq.all
  end

  def show
  end

  def general
    @faqs = Faq.all
  end

  def new
    @faq = Faq.new
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to faqs_path, notice: 'Faq was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @faq.update(faq_params)

    redirect_to faqs_path
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

  def authorize_faq
    authorize @faq || Faq
  end
end
