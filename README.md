# fitnutri-db

Banco de dados do **Sistema de Acompanhamento de Atividade Física e Nutrição para Bem-Estar**, desenvolvido como Projeto Integrador da disciplina de Banco de Dados — Tema 9.

O sistema unifica em uma única base o acompanhamento físico e nutricional de pacientes: cadastro, consultas com educadores físicos e nutricionistas, prescrição de treinos e planos alimentares, evolução ao longo do tempo, histórico de alterações e o controle financeiro dos planos contratados.

## Discentes

- Allan Guilherme da Silva Vieira
- Lucas Nobrega de Araujo
- Raffael Wagner Rolim Siqueira

## Tecnologia

PostgreSQL 18. Nada no esquema depende de recurso exclusivo dessa versão — os scripts funcionam da 12 em diante.

## Estrutura

```
fitnutri-db/
├── database/
│   ├── schema.sql              49 tabelas e 52 chaves estrangeiras
│   ├── data.sql                carga inicial de dados
│   ├── reset.sql               remove todas as tabelas e funções
│   └── triggers/
│       ├── imc.sql             cálculo automático do IMC
│       └── valor_liquido.sql   cálculo automático do valor líquido
└── docs/
    ├── DER.drawio.xml          diagrama entidade-relacionamento
    ├── modelo-logico.docx      esquema lógico relacional
    ├── dicionario-dados.docx   dicionário de dados
    ├── correcoes/              devolutivas recebidas
    └── tema-9.pdf              enunciado do projeto
```

## Como executar

```bash
createdb fitnutri

psql -d fitnutri -f fitnutri-db/database/schema.sql
psql -d fitnutri -f fitnutri-db/database/triggers/imc.sql
psql -d fitnutri -f fitnutri-db/database/triggers/valor_liquido.sql
psql -d fitnutri -f fitnutri-db/database/data.sql
```

Os gatilhos precisam vir depois do `schema.sql`, porque referenciam as tabelas. Para recriar do zero, rode `reset.sql` antes de toda a sequência.

## O modelo

49 tabelas, organizadas no `schema.sql` nos mesmos módulos do diagrama:

| Módulo | Conteúdo |
|---|---|
| `BASE` | Paciente, profissional, plano de serviço, exercício, alimento e evolução |
| `PACIENTE` | Telefones, contatos de emergência, restrições, doenças, alergias e medicamentos |
| `PROFISSIONAIS` | Disponibilidade, telefones, as subclasses nutricionista e educador físico, e suas especialidades |
| `CONSULTAS` | Consultas físicas e nutricionais e seus atributos multivalorados |
| `TREINO` | Plano de treino, objetivos, exercícios prescritos e observações técnicas |
| `NUTRICAO` | Plano alimentar, refeições e os alimentos de cada refeição |
| `EVOLUCAO` | Subclasses de evolução física e nutricional, observações e metas |
| `FINANCEIRO` | Serviços do plano, contratação, pagamentos e observações |
| `HISTORICO` | Alterações realizadas nos planos de treino e alimentares |

Números do esquema: 52 chaves estrangeiras, 69 restrições de unicidade, 54 verificações de domínio, 8 funções e 7 gatilhos.

## Decisões de modelagem

**Especialização.** Há duas hierarquias, ambas mapeadas mantendo a relação da superclasse e criando uma relação por subclasse com a chave da superclasse como chave primária. `PROFISSIONAL` é uma especialização **sobreposta e total** — o mesmo profissional pode ser nutricionista e educador físico. `EVOLUCAO` é **disjunta e total**. A disjunção e a totalidade não são expressáveis em SQL padrão e precisam ser garantidas pela aplicação.

**Atributos derivados.** O DER marca três atributos como derivados, e cada um é tratado de um jeito:

- `valor_calorico_porcao` é uma coluna gerada `STORED`, calculada a partir dos macronutrientes da própria tabela.
- `IMC` e `valor_liquido` dependem de colunas de outras tabelas, o que coluna gerada não permite. São calculados por gatilho, e a escrita manual nesses campos é bloqueada.

**Exclusão lógica.** Registros não são removidos fisicamente. As chaves estrangeiras que apontam para cadastros, consultas, prescrições e contratos usam `ON DELETE RESTRICT`, e a desativação é feita pelo campo `status`. As tabelas de atributo multivalorado usam `ON DELETE CASCADE`, por serem parte do próprio registro.

**Histórico de alterações.** `HISTORICO_PLANO_TREINO` e `HISTORICO_PLANO_ALIMENTAR` registram cada mudança nos planos, com data, descrição e o profissional responsável — que pode ser diferente de quem prescreveu o plano originalmente.

## Convenções do SQL

- Chaves primárias substitutas usam `GENERATED ALWAYS AS IDENTITY`, então o valor nunca é informado no `INSERT`.
- Dentro do `CREATE TABLE` ficam as colunas, a chave primária, as restrições de unicidade e as verificações, nessa ordem e separadas por linha em branco.
- Chaves estrangeiras ficam em `ALTER TABLE`, agrupadas no fim do `schema.sql`.
- Identificadores são escritos sem aspas e sem acentos; o PostgreSQL os normaliza para minúsculas.
