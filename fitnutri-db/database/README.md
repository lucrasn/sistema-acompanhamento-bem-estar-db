# Database

Scripts de criação, carga e reset do banco.

| Arquivo | Conteúdo |
|---|---|
| `schema.sql` | As 49 tabelas, agrupadas por módulo, e as 52 chaves estrangeiras no fim |
| `triggers/imc.sql` | Cálculo automático do IMC em `EVOLUCAO` |
| `triggers/valor_liquido.sql` | Cálculo automático do valor líquido em `PAGAMENTO` |
| `data.sql` | Carga inicial de dados |
| `reset.sql` | Remove todas as tabelas e funções |

## Ordem de execução

```bash
psql -d fitnutri -f database/schema.sql
psql -d fitnutri -f database/triggers/imc.sql
psql -d fitnutri -f database/triggers/valor_liquido.sql
psql -d fitnutri -f database/data.sql
```

Os gatilhos precisam vir depois do `schema.sql`, porque referenciam as tabelas. Rode `reset.sql` antes da sequência para recriar do zero.

## Convenções

- Chaves primárias substitutas usam `GENERATED ALWAYS AS IDENTITY`, então o valor nunca é informado no `INSERT`.
- Dentro do `CREATE TABLE` ficam as colunas, a chave primária, as restrições de unicidade e as verificações, nessa ordem e separadas por linha em branco.
- Chaves estrangeiras ficam em `ALTER TABLE`, agrupadas no fim do `schema.sql`.
- Identificadores são escritos sem aspas e sem acentos; o PostgreSQL os normaliza para minúsculas.
