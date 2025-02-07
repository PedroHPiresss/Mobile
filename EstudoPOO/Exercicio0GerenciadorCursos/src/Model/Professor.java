package Model;

public class Professor extends Pessoa{
    // encapsulamento
    // atributos - privados

    private double salario;

    //construtor
    public Professor(String nome, String cpf, double salario) {
        super(nome, cpf);
        this.salario = salario;
    }

    //getters and setters
    public double getSalario() {
        return salario;
    }

    public void setSalario(double salario) {
        this.salario = salario;
    }

    //polimorfismo - override - exibirInformações

    @Override //exibirInformações
    public void ExibirInformacoes() {
        super.ExibirInformacoes();
        System.out.println("Salário: "+getSalario());
    }
}
