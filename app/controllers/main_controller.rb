class MainController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:endpoint_one]

  def index
  end

  def endpoint_one
    persona = {
        nombre: "nombre",
        apellido: "ape",
        cuil: "cuil",
        code: "code",
        fechanacimiento: "10/10/10",
        telefono: "123",
        nrocelular: "123",
        mail: "test@end.com",
        domicilio: "siempre viva 123",
        localidad: "crv",
        provincia: "chubut",
        idlocalidad: "1548",
        dueno: "117"
    }

    render json: { persona: persona, error: false }
  end
end
