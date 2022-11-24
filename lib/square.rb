class Square

    def initialize(sign)
        @sign = sign
        @final_sign = sign
    end

    attr_accessor :sign

    def change_sign(sign)
        @sign = sign
    end

end

class ShipSquare < Square
 
    def initialize(sign)
        @sign = sign
    end

end
