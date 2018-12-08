require 'sqlite3'

class Operacao
  attr_accessor :id, :tipo, :moeda, :cotacao, :total

  @@db = SQLite3::Database.open 'cambio.db'

  # Cria a tabela de transações
  @@db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS transactions (
      id integer primary key autoincrement not null,
      tipo text not null,
      moeda text not null,
      cotacao real not null,
      total real not null,
      caixa_id integer not null,
      FOREIGN KEY (caixa_id) REFERENCES cashiers(id)
    );
  SQL

  @@db.close

  def initialize(tipo:, moeda:, cotacao:, total:)
    @tipo = tipo
    @moeda = moeda
    @cotacao = cotacao
    @total = total
  end

  def valor_total(dolar, real, operacao, moeda)
    if (operacao == 'compra') && (moeda == 'dolar')
      puts "O valor necessário para a operação é R$#{real}."
    elsif (operacao == 'compra') && (moeda == 'real')
      puts "O valor necessário para a operação é $#{dolar}."
    elsif (operacao == 'venda') && (moeda == 'dolar')
      puts "Essa venda irá render R$#{real}."
    elsif (operacao == 'venda') && (moeda == 'real')
      puts "Essa venda irá render $#{dolar}."
    else
      puts 'Operação inválida'
    end
  end

  def confirmar?
    puts 'Confirmar? [S/N] '
    resposta = gets.chomp.upcase
    return true if resposta == 'S'

    puts 'Transação cancelada.'
    false
  end

  def salvar(caixa_id)
    @@db = SQLite3::Database.open 'cambio.db'
    @@db.execute('INSERT INTO transactions (tipo, moeda, cotacao, total, caixa_id) VALUES (?, ?, ?, ?, ?)', [tipo, moeda, cotacao, total, caixa_id])
    @@db.close
  end
end
