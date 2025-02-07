package Controller;

import java.util.ArrayList;
import java.util.List;

import Model.Aluno;
import Model.Professor;

public class Curso {
    //atributos - privados
    private String nomeCurso;
    private Professor professor;
    private List<Aluno> alunos;
    
    //métodos - públicos
    //construtor
    public Curso(String nomeCurso, Professor professor) {
        this.nomeCurso = nomeCurso;
        this.professor = professor;
        this.alunos = new ArrayList<>();
    }
    //adicionar alunos
    public void adicionarAluno(Aluno aluno){
        alunos.add(aluno);
    }
    //exibir as informações do curso
    public void exibirInformacoesCurso(){
        System.out.println("Nome do Curso: "+nomeCurso);
        System.out.println("Nome do Professor: "+professor.getNome());
        //loop - foreach
        for (Aluno aluno : alunos) {
            int i = 1;
            System.out.println(i+"."+aluno.getNome());
            i++;
        }
        //exibirStatusAluno
        
    }
}
