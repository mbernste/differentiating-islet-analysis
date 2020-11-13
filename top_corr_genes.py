import pandas as pd
from scipy.stats import pearsonr

df = pd.read_csv('differentiating_islets.log2_TPM.tsv', sep='\t', index_col=0)
df = df.drop(['day', 'include_in_time_series', 'sample_type'], axis=1)
print(df)

gene_to_top_corr = {}
for i, gene_a in enumerate(df.columns):
    if i % 100 == 0:
        print('Processed {}/{} genes'.format(i, len(df.columns)))
    #if i > 3:
    #    break
    a_expr = df[gene_a]
    corrs = []
    for gene_b in df.columns:
        if gene_b == gene_a:
            continue
        b_expr = df[gene_b]
        corr, _ = pearsonr(a_expr, b_expr)
        corrs.append((gene_b, corr))
    corrs = sorted(corrs, key=lambda x: x[1], reverse=True)
    #print(gene_a)
    #print(corrs[:10])
    gene_to_top_corr[gene_a] = [c[0] for c in corrs[:500]]

df_out = pd.DataFrame(
    data=gene_to_top_corr
)
df_out = df_out.transpose()
df_out.to_csv('top_correlated.tsv', sep='\t')
