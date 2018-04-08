class CampInstructorsController < ApplicationController
  before_action :set_camp_instructor, only: [:show, :edit, :update, :destroy]

  # GET /camp_instructors
  # GET /camp_instructors.json
  def index
    @camp_instructors = CampInstructor.all
  end

  # GET /camp_instructors/1
  # GET /camp_instructors/1.json
  def show
  end

  # GET /camp_instructors/new
  def new
    @camp_instructor = CampInstructor.new
  end

  # GET /camp_instructors/1/edit
  def edit
  end

  # POST /camp_instructors
  # POST /camp_instructors.json
  def create
    @camp_instructor = CampInstructor.new(camp_instructor_params)

    respond_to do |format|
      if @camp_instructor.save
        format.html { redirect_to @camp_instructor, notice: 'Camp instructor was successfully created.' }
        format.json { render :show, status: :created, location: @camp_instructor }
      else
        format.html { render :new }
        format.json { render json: @camp_instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /camp_instructors/1
  # PATCH/PUT /camp_instructors/1.json
  def update
    respond_to do |format|
      if @camp_instructor.update(camp_instructor_params)
        format.html { redirect_to @camp_instructor, notice: 'Camp instructor was successfully updated.' }
        format.json { render :show, status: :ok, location: @camp_instructor }
      else
        format.html { render :edit }
        format.json { render json: @camp_instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /camp_instructors/1
  # DELETE /camp_instructors/1.json
  def destroy
    @camp_instructor.destroy
    respond_to do |format|
      format.html { redirect_to camp_instructors_url, notice: 'Camp instructor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camp_instructor
      @camp_instructor = CampInstructor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def camp_instructor_params
      params.require(:camp_instructor).permit(:camp_id, :instructor_id)
    end
end
