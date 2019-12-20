# thesis

last-update 2019-12-20

-------------------------------------------------
## Command

```
# git clone と更新
git clone https://github.com/19971112/thesis.git
mv *.sh.* job/
mv *.job.* job/

git pull origin master

# 置換リストの作成
bash scripts/1_make_replacelist.sh

# データセットの用意
qsub scripts/2_DL_dataset.sh

# 16S rRNAに基づく系統解析
qsub scripts/16S_phylogeny_2019-11-04.sh
qsub scripts/16S_phylogeny.sh
qsub scripts/16S_phylogeny2.sh

# RSCUの解析
qsub scripts/RSUC.sh

# RSCUのヒートマップ
qsub scripts/RSCU_heatmap.job

# ゲノムの特徴解析（総塩基数 Size、GC含量 GC、遺伝子数 tRNA rRNA cds highlyExpressed、コドン使用バイアス S_value delta_enc）
bash scripts/genome_signature.sh
bash scripts/genome_signature2.sh &

# 系統樹と表の並び替え
qsub scripts/table_sort.job

# 多変量解析
qsub scripts/WCA.job
qsub scripts/WCA2.job
qsub scripts/WCA3.job
qsub scripts/WCA4.job
```

