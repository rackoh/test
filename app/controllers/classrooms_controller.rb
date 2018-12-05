class ClassroomsController < ApplicationController
  
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]

  PAGE = 1
  PAGE_SIZE = 20

  def index
    @classrooms = Classroom.all.paginate( :page => (params[:page]|| PAGE), 
                                      :per_page => (params[:pageSize]|| PAGE_SIZE) )
  end

  def show
    @classroom = Classroom.find(params[:id])
    @students = @classroom.students.paginate( :page => (params[:page]|| PAGE), 
                                      :per_page => (params[:pageSize]|| PAGE_SIZE) )
  end

  def new
    @classroom = Classroom.new
  end

  def edit
    @classroom = Classroom.find(params[:id])
  end

  def create
    @classroom = Classroom.new(classroom_params)

    respond_to do |format|
      if @classroom.save
        format.html { 
          
          redirect_to classrooms_path, notice: "New Class Room Created"
         }
        format.json { render :show, status: :created, location: @classroom }
      else
        format.html { render :new }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @classroom.update(classroom_params)
        format.html { redirect_to @classroom, notice: 'Classroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @classroom }
      else
        format.html { render :edit }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @classroom.destroy
    respond_to do |format|
      format.html { redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_classroom
      @classroom = Classroom.find(params[:id])
    end

    def classroom_params
      params.require(:classroom).permit(:name, :code, :active, :students_attriutes)
    end
end
