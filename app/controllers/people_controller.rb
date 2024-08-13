class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people or /people.json
  def index
    filter = Person.select(:id, :name, :company, :dni)
              .where('name LIKE ? ', "%#{params[:query]}%")
              .or(Person.where("company LIKE ? ", "%#{params[:query]}%"))
              .order(:name)
              .order(:company)
    @pagy, @people = pagy(filter)
  end

  # GET /people/1 or /people/1.json
  def show
    pdf = HexaPDF::Document.open( Rails.root.join('app/assets/images/etiqueta.pdf') )
    page = pdf.pages[0]
    canvas = page.canvas(type: :overlay)
    # company_x = (@person.company.length < 10 ) ? 50 : 30
    if @person.name.length > 20
      person_name = @person.name.split(' ')
      first_name = person_name.pop
      last_name = person_name.join(' ')
      canvas.font('Helvetica', size: 22).text(last_name, at: [20, 80])
      canvas.font('Helvetica', size: 22).text(first_name, at: [20, 50])
      canvas.font('Helvetica', size: 18).text(@person.company, at: [30, 20])
    else
      name_x = ( @person.name.length > 18 ) ? 10 : 30
      canvas.font('Helvetica', size: 22).text(@person.name, at: [name_x, 80])
      canvas.font('Helvetica', size: 18).text(@person.company, at: [30, 40])
    end
    pdf.write('public/etiqueta.pdf')

    respond_to do |format|
      format.html do
        send_file( 'public/etiqueta.pdf', filename: 'etiqueta.pdf', type: 'application/pdf', disposition: 'attachment')
      end
    end
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.prepend("tbody_people", 
              partial: "people/person", 
              locals: { person: @person })
          ]
        }
        format.html { redirect_to person_url(@person), notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@person)
        }
        format.html { redirect_to person_url(@person), notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to people_url, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import_data()
    xlsx = Roo::Spreadsheet.open('public/personas.xlsx')
    xlsx.sheet(0).each_with_index(lastname: 'Apellido', name: 'Nombre',  
                                  company: 'Empresa') do |row, row_index|
                                  
        next if row_index == 0

        Person.create(
            name: "#{row[:lastname]} #{row[:name]}",
            company: row[:company]
        )
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:name, :dni, :company)
    end
end
