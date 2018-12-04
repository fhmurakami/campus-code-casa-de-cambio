class Operacao
  attr_accessor :id, :tipo, :moeda, :cotacao, :total

  @@ultimo_id = 0

  def initialize(tipo, moeda, cotacao, total)
    @tipo = tipo
    @moeda = moeda
    @cotacao = cotacao
    @total = total
    @id = @@ultimo_id + 1
    @@ultimo_id = @id
  end
      
end