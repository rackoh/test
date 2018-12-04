class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  
  def index
    if invalid_active_state || invalid_classroom_ids
      @students = []
    elsif (!params[:active].nil? || params[:admissionYearAfter].present? || params[:admissionYearBefore].present? || params[:classes].present?)
      @students = Student.where(search_query)
    else
      @students = Student.all
    end
  end

  def show
    @students = Student.find(params[:id])
  end

  def new
    @classroom = Classroom.find(params[:classroom][:id])
    @student = Student.new
  end

  def edit
    @student = Student.find(params[:id])
  end

  def create
    @classroom = Classroom.find(params[:student][:classroom_id])
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to classroom_path(@classroom), notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    params["student"]["active"]=false
    @student.update(student_params)
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully marked in-active.' }
      format.json { head :no_content }
    end
  end

  private

    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:name, :admission_year, :active, :classroom_id, :admissionYearAfter, :admissionYearBefore)
    end

    def index_params
      params.permit(:name, :admission_year, :active, :classroom_id)
    end

    def search_params
      search = {}
      search[:active] = (params[:active].to_s == "true") if params[:active].present?
      search[:classroom_id] = params[:classes] if params[:classes].present?
      search
    end

    def search_query
      query = ""
      query << " active = #{params[:active]} AND" unless params[:active].nil?
      query << " admission_year > #{params[:admissionYearAfter].to_i} AND" if params[:admissionYearAfter].present?
      query << " admission_year < #{params[:admissionYearBefore].to_i} AND" if params[:admissionYearBefore].present?
      query << " classroom_id in (#{@class_ids}) AND" if params[:classes].present?
      query[1..-5]
    end

    def invalid_active_state
      (params[:active].present? && !["true","false"].include?(params[:active]))
    end

    def invalid_classroom_ids
      (params[:classes].present? && classroom_ids.empty?)
    end

    def classroom_ids
      @class_ids = Classroom.where("name in (#{params[:classes]})").ids.join(",")
    end

end
