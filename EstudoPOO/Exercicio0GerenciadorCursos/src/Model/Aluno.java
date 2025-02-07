package Model;

public class Aluno extends Pessoa implements Avaliavel{
    //encapsulamento
    //atributos - privados
    private String matricula;
    private double nota;
    //métodos - públicos
    //construtor
    public Aluno(String nome, String cpf, String matricula, double nota) {
        super(nome, cpf);
        this.matricula = matricula;
        this.nota = nota;
    }
    //getters and setters
    public String getMatricula() {
        return matricula;
    }
    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }
    public double getNota() {
        return nota;
    }
    public void setNota(double nota) {
        this.nota = nota;
    }
    
    @Override //exibirInformações
    public void ExibirInformacoes() {
        super.ExibirInformacoes();
        System.out.println("Matricula: "+getMatricula());
        System.out.println("Nota: "+getNota());
    }

    //Incluir o método abstrato avaliarDesempenho
    @Override
    public void avaliarDesempenho(){
        if (nota >= 6) {
            System.out.println("Aluno aprovado");
        } else{
            System.out.println("Aluno Reprovado");
        }
    }
}
