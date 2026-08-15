# Comentários DER
## Problemas de modelagem
### Graves (comprometem integridade ou requisito)
1. Quebra de integridade referencial em REFEICAO_CONTEM_ALIMENTO. REFEICAO é entidade fraca com PK composta (id_plano_alimentar, horario, nome). A tabela de ligação, porém, tem PK (id_alimento, id_plano_alimentar) — não propaga a chave completa da entidade fraca. Consequência: não é possível saber a qual refeição do plano o alimento pertence, e um mesmo alimento não pode aparecer em duas refeições do mesmo plano. O mesmo defeito se repete em OBSERVACAO_REFEICAO. Regra (Elmasri, cap. 9, passo 2): a chave de uma entidade fraca é chave parcial + chave da entidade proprietária, e toda relação que a referencie deve importar a chave inteira.
2. PLANO_SERVIÇO com id_paciente (FK, marcado como Único). Um plano de serviço é catálogo comercial, não pertence a um paciente. Com UNIQUE, o esquema permite um único plano por paciente e duplica a associação que já existe em CONTRATA_PLANO, criando dependência transitiva e risco de anomalia. O DER está correto neste ponto; o dicionário é que diverge — o campo deve ser removido.
### Médios (qualidade conceitual)
1. Redundância entre EVOLUCAO e as consultas. peso, perc_gordura e IMC existem simultaneamente em EVOLUCAO, CONSULTA_FISICA e (parcialmente) CONSULTA_NUTRICIONAL, com relacionamento 1..1 entre evolução e consulta. Como a evolução é medida na consulta, o conjunto é redundante e sem restrição que garanta consistência entre as duas cópias. Duas saídas defensáveis: (a) manter os dados de medição só na consulta e derivar a evolução por consulta ordenada no tempo; (b) manter EVOLUCAO como entidade e retirar as medidas duplicadas da consulta. A situação atual — as duas coisas ao mesmo tempo — é a única que não se sustenta.
2. Atributos duplicados no mesmo objeto. PLANO_TREINO tem a coluna obj_treino e a tabela OBJETIVO_TREINO; tem obs_geral e OBSERVACAO_GERAL. PLANO_ALIMENTAR repete o padrão com observacoes / OBS_PLANO_ALIMENTAR. Também há cond_fisico em CONSULTA_FISICA e em PLANO_TREINO. Escolher um dos dois em cada par.
3. Fragmentação excessiva de atributos textuais. Recomendações, observações gerais, observações clínicas, hábitos alimentares e objetivos foram tratados como multivalorados, gerando ~15 tabelas cujo único conteúdo é texto livre. Não é erro formal, mas há custo de projeto; e todas essas tabelas usam campo TEXT como parte da chave primária, o que é má prática (índice sobre texto longo, impossibilidade de repetir a mesma observação, comparação sensível a espaços). Usar chave substituta sequencial + FK.
4. disponibilidade como atributo composto monovalorado (item RF02/RF03). Deveria ser multivalorado composto ou entidade fraca DISPONIBILIDADE(dia_semana, hora_inicio, hora_fim).
5. Duplicação de dados clínicos do paciente na consulta nutricional (alergias, restrições_alimentares) — já existem em PACIENTE. É aceitável se a intenção for registrar o quadro na data da consulta (snapshot), mas isso precisa estar documentado; caso contrário é redundância.
## Notação
1. Especialização sem marcação de disjunção e totalidade. As duas hierarquias usam círculo vazio + triângulo, ligados por linha simples. Na notação de Elmasri, a restrição de disjunção é indicada por d (disjunta) ou o (sobreposta) dentro do círculo, e a totalidade por linha dupla entre superclasse e círculo. Do jeito que está, o diagrama comunica especialização parcial e sem restrição de disjunção — o oposto do pretendido. Correção: d no círculo e linha dupla nas duas hierarquias.
2. Nenhum atributo derivado marcado. IMC é grandeza calculada (peso/altura²) e está armazenada em duas entidades sem qualquer indicação de derivação (elipse tracejada). Idem valor líquido do pagamento após desconto/multa.
3. CONTEM (REFEICAO × ALIMENTO) desenhado como losango duplo. Losango duplo é relacionamento identificador, reservado para entidade fraca. ALIMENTO é entidade forte; o losango deve ser simples.
4. Chaves das subclasses. EDUCADOR_FISICO e NUTRICIONISTA (e as duas subclasses de EVOLUCAO) receberam PK substituta própria (id_educador, id_nutricionista) com FK única para a superclasse. Funciona, mas o mapeamento canônico de especialização (Elmasri, cap. 9, opção 8B) usa a chave da superclasse como PK da subclasse, evitando dois domínios de identidade para a mesma pessoa. Note ainda que CONSULTA_FISICA referencia id_educador e não id_profissional — coerente com a escolha, mas exige cuidado nas consultas.
## Verificação requisito a requisito
### Requisitos funcionais
RF Situação Observação
- RF01 Cadastro de pacientes ⚠ Parcial Falta endereço completo: só existem endereco_cep, endereco_cidade, endereco_estado. Não há logradouro, número, complemento nem bairro. O enunciado pede "endereço completo"
- RF02 Educadores físicos ⚠ Parcial Todos os campos presentes, mas disponibilidade é atributo composto monovalorado (um único intervalo dia_ini–dia_fim / hora_ini–hora_fim). Não representa agenda com múltiplas faixas (ex.: seg/qua 8h–12h e ter/qui 14h–18h)
- RF03 Nutricionistas ⚠ Parcial Mesma limitação de disponibilidade
- RF04 Consultas com educadores ✅ Atendido Todos os 16 itens presentes (incl. pressão arterial, IMC, condicionamento)
- RF05 Prescrição de treinos ✅ Atendido Plano + N:M com EXERCICIO carregando série, repetição, carga, tempo, intervalo. Ressalva: obs_tecnicas está em EXERCICIO (catálogo) e não na prescrição
- RF06 Evolução física ✅ Atendido EVOLUCAO + EVOLUCAO_FISICA cobrem peso, %gordura, massa muscular, IMC, circunferências, desempenho, observações e metas
- RF07 Consultas nutricionais ✅ Atendido Todos os itens presentes
- RF08 Planos alimentares ⚠ Parcial Refeições e itens corretos, mas "substituições permitidas" foi modelado como BOOLEAN — registra se pode substituir, não por quê. O requisito pede as substituições permitidas
- RF09 Evolução nutricional ✅ Atendido EVOLUCAO_NUTRICIONAL com aderência, consumo calórico e evolução clínica
- RF11 Controle financeiro ⚠ Parcial PAGAMENTO completo, porém o vínculo com o serviço contratado está inconsistente (ver 5.1)
- RF12 Planos e mensalidades ⚠ Parcial PLANO_SERVIÇO + SERVIÇO + CONTRATA_PLANO corretos no DER, mas o dicionário insere id_paciente dentro de PLANO_SERVIÇO (ver 5.2)
- RF13 Consultas operacionais ✅ Atendido Derivável do esquema (agenda, pendências, ativos)
- RF14 Relatórios gerenciais ✅ Atendido Derivável; faturamento e inadimplência possíveis via status_pag e data_venc
### Regras de negócio
- RN Situação Observação
- RN01–RN03 ✅ Cardinalidades 0..N corretas nos dois eixos de acompanhamento
- RN04 / RN05 ✅ Planos herdam paciente e profissional da consulta de origem — solução elegante e correta
- RN07 ✅ Múltiplas evoluções por paciente via múltiplas consultas
- RN08 (pagamento × serviço contratado) ⚠ O DER liga PAGAMENTO a CONTRATA_PLANO (GERA), mas a tabela PAGAMENTO do dicionário tem apenas id_paciente
- RN09 ✅ status_pag + data_venc 
- RN10 ✅ Tratável em regra de aplicação/visão
- RN11 (identificação profissional única) ✅ CREF e CRN com UNIQUE
- RN12 (registro permanente) ⚠ Há campos status, mas o dicionário não declara política de exclusão lógica; sem RN06 o histórico de prescrições fica incompleto
# Comentários Projeto Relacional
## Divergências encontradas
### Erros de transformação (esquema lógico × DER) — críticos
    Onde O que está O que o DER exige Efeito
1. Evolucao_Fisica(id_evolucao_fisica, circ_abdominal, circ_toracica, desempenho_fisico, massa_muscular, \#id_consulta_fisica*) Sem \#id_evolucao Especialização total EVOLUCAO → {EVOLUCAO_FISICA, EVOLUCAO_NUTRICIONAL} exige FK para a superclasse (o dicionário tem id_evolucao FK) A subclasse fica órfã: peso, IMC, medida_corporal, data_avaliacao, observações e metas ficam inacessíveis para a evolução física. RF06 deixa de ser recuperável por junção
2. Pagamento(id_pagamento, \#id_paciente*, …) FK para Paciente O DER liga PAGAMENTO —GERA— CONTRATA_PLANO (1..N / 1..1) ⇒ FK composta \#id_paciente, \#id_plano_servico O relacionamento GERA não foi transformado. Mensalidade não é rastreável ao contrato (viola RN08) e RF11/RF14 (inadimplência por plano) fica inviável
3. Refeicao_Contem_Alimento(#id_alimento, \#id_plano_alimentar, …) e Observacoes_Refeicao(idem) FK aponta para Plano_Alimentar REFEICAO é entidade fraca de PK (id_plano_alimentar, nome, horario); a FK precisa importar as três colunas Impossível saber a qual refeição o alimento pertence; o mesmo alimento não pode aparecer em duas refeições do mesmo plano
4. Contrata_Plano(status_contratacao, data_de_adesao, \#id_plano_servico, \#id_paciente) — PK = (id_plano_servico, id_paciente) data_de_adesao fora da PK Entidade associativa cujo atributo próprio distingue as ocorrências Um paciente não pode recontratar o mesmo plano em outra data (RF12 — histórico de adesões)
5. Plano_Servico(…, \#id_paciente*) FK para Paciente Não existe esse relacionamento no DER — o vínculo paciente↔plano é Contrata_Plano Relação espúria; duplica a associação, cria dependência transitiva e (com o UNIQUE do dicionário) limita a um plano por paciente
### Divergências entre esquema lógico e dicionário de dados
- Chave primária
- Relação PK no dicionário PK no esquema lógico Correta
- Telefone_Paciente (id_paciente, numero_telefone) nenhuma sublinhada dicionário
- Contato_Emergencia (id_paciente, nome) (id_paciente, nome, numero) dicionário (embora a do lógico seja mais defensável)
- Especialidade_Educador (id_educador, especializacao) (id_educador) apenas dicionário — como está no lógico, o educador só teria uma especialidade
- Objetivo_Treino (id_plano_treino, objetivos) (id_plano, objetivos) dicionário — \#id_plano não existe em nenhum artefato
- Colunas presentes em um artefato e ausentes no outro
- Relação Só no esquema lógico Só no dicionário Leitura
- Consulta_Fisica objetivo_paciente, recomendacao, obs_geral — Atributo multivalorado mapeado duas vezes: as colunas coexistem com as tabelas Objetivo_paciente, Recomendacoes_Fisicas, Observacoes_gerais. Violação de 1FN na versão do lógico
- Plano_Treino — cond_fisico, obj_treino, obs_geral Aqui o lógico está certo (obj_treino e obs_geral são multivalorados, já têm tabela; cond_fisico não existe no DER) — o dicionário é que sobra
- Evolucao_Fisica — id_evolucao Item 1 de §4.1
- Nomes divergentes para o mesmo objeto (o mesmo elemento aparece com dois nomes nos dois artefatos):
- Obs_Evolucao↔OBSERVACAO_EVOLUCAO · Objetivo_paciente↔OBJETIVOS_PACIENTE · Habito_alimentar↔HABITOS_ALIMENTARES · Restricao_Alimentar_Consulta↔RESTRICOES_ALIMENTARES_CONSULTA · Observacoes_Refeicao↔OBSERVACAO_REFEICAO · colunas: alergia↔alergias, intolerancia↔intolerancias, recomendacao↔recomendacoes, observacoes↔observacoes_gerais, obs_geral↔observacoes, observacao↔obs_contrato, unidade_de_medida↔und_medida, observacao_geral↔observacoes, objetivo↔objetivo_paciente, restricao_alimentar↔limitacoes_alimentares_consulta, habito alimentar↔habitos_alimentares.
- Erros de digitação que quebram a implementação: satus_pag (deveria ser status_pag), habito alimentar (identificador com espaço), \#id_Pagamento (caixa divergente), id_plano_serviço e serviços (cedilha em identificador).
### Passo O que exige Situação
1. Entidades fortes Uma relação por entidade forte, PK = chave do DER ✅ Todas as 12 entidades fortes do DER viraram relações
2. Entidades fracas PK = chave parcial + PK do proprietário ⚠️ Refeicao(#id_plano_alimentar, nome, horario) está correto, mas as relações que a referenciam não importam a chave completa (§4.1, item 3)
3. Relacionamentos 1:1 FK no lado de participação total n/a (não há 1:1 no DER)
4. Relacionamentos 1:N FK no lado N ❌ Falha em Pagamento (FK foi para Paciente em vez de Contrata_Plano) e em Evolucao_Fisica (FK para a superclasse ausente)
5. Relacionamentos N:M Relação própria com PK composta ✅ Consulta_Fisica, Consulta_Nutricional, Contrata_Plano, Plano_Treino_Pode_Conter_Exercicio, Refeicao_Contem_Alimento — com ressalvas em §4.1 (itens 3 e 4)
6. Atributos multivalorados Relação própria com PK = FK + atributo ✅ 20 relações criadas corretamente; 2 com PK mal declarada (§4.2)
7. Relacionamentos n-ários Relação própria n/a
8. Especialização/Generalização Relação por subclasse com FK para a superclasse (opção 8B) ⚠️ Correto em Nutricionista e Educador_Fisico; Evolucao_Fisica perdeu a FK \#id_evolucao
# Resultado global
## Verificação Resultado
- Relações no esquema lógico 48
- Tabelas no dicionário 48
- Relações do esquema lógico sem correspondente no dicionário 0 (5 apenas com nome divergente)
- Passos de mapeamento aplicados corretamente 6 de 8 (falhas nos passos 4 e 8)
- Relações com divergência de PK entre lógico e dicionário 4
- Relações com divergência de FK entre lógico e dicionário 2
- Relações com divergência de nome de coluna 12
- Divergências de obrigatoriedade (* × coluna "Nulo") 34
- Restrições UNIQUE do dicionário invisíveis no esquema lógico 11
