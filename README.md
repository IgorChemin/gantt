# Gráfico de Gantt - Projeto Flutter Web

Este projeto foi desenvolvido com o intuito de validar a criação de um gráfico de Gantt utilizando Flutter Web (versão 3.22.3) e Dart (versão 3.4.4). O gráfico de Gantt tem como objetivo exibir as tarefas de um projeto e permitir filtros por EDT (Estrutura de Detalhamento de Trabalho). O projeto está atualmente em pausa enquanto a estrutura do projeto é reformulada de acordo com novas diretrizes.

## Exemplo de Gráfico de Gantt

Aqui está uma visualização do gráfico de Gantt atual (ainda em desenvolvimento):

![Gráfico de Gantt](imagens/gantt-chart.png)


## Objetivo

Inicialmente, a estrutura do projeto foi planejada com dois níveis de detalhamento:

- **Projeto**
  - **EDT 01** (Estrutura de Detalhamento de Trabalho)
    - Tarefa
  - **EDT 02** (Estrutura de Detalhamento de Trabalho)
    - Tarefa

O gráfico de Gantt foi desenvolvido para apresentar tarefas e permitir filtros baseados nas diferentes EDTs. Contudo, após uma revisão do gerente de projeto, foi determinado que a estrutura do projeto precisa ser adaptada para incluir **subníveis** adicionais, o que implica que o gráfico de Gantt também precisará ser refeito para refletir esses novos níveis de detalhamento.

## Situação Atual

Devido à mudança na estrutura do projeto, a implementação do gráfico de Gantt foi temporariamente interrompida. O trabalho agora está focado em ajustar a estrutura do projeto para atender aos requisitos do gerente, antes de continuar com a implementação do gráfico de Gantt.

## O que falta

- **Ajuste da Estrutura do Projeto:** Atualização da estrutura do projeto para incluir mais níveis de detalhamento. Isso implicará na reorganização de como as tarefas estão estruturadas, incluindo subníveis.
  
- **Gráfico de Gantt com Subníveis:** Após a mudança na estrutura do projeto, será necessário atualizar o gráfico de Gantt para suportar múltiplos níveis e garantir que ele seja capaz de exibir corretamente as tarefas e subtarefas.

## Como Rodar

Para rodar o projeto localmente, siga os seguintes passos:

1. Clone este repositório:
   ```bash
   git clone https://github.com/seu-usuario/gantt-chart-flutter.git

