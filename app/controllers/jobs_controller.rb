class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]

  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.published.order('wage_lower_bound DESC')
    when 'by_upper_bound'
      Job.published.order('wage_upper_bound DESC')
    else
      Job.published.recent
    end
  end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "这份工作已经被归档"
      redirect_to root_path
    end
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to jobs_path, notice: "创建成功！"
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path, notice: "更新成功！"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path, alert: "删除成功！"
  end

  private

  def job_params
    params.require(:job).permit(:title, :descritpion, :wage_upper_bound, :wage_loweer_bound, :contact_email, :is_hidden)
  end

end
