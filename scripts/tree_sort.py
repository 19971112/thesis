import argparse    # 1. argparseをインポート
from ete3 import Tree, TreeStyle
import pandas as pd

parser = argparse.ArgumentParser(description='系統樹と表の並び替え')   
parser.add_argument('-n', '--newick', help='newick file') 
parser.add_argument('-t', '--table', help='table file, sep = tab, first line index')
parser.add_argument('-o1', '--outgroup1', help='set outgroup1')   
parser.add_argument('-o2', '--outgroup2', help='set outgroup2')  
args = parser.parse_args() 

NEWICK = args.newick
g_genome = args.table
OUTG1 = args.outgroup1
OUTG2 = args.outgroup2

# 系統樹の読み込み
t = Tree(NEWICK , format= 0)
ancestor = t.get_common_ancestor(OUTG1,OUTG2)
t.set_outgroup( ancestor )
ts = TreeStyle()
ts.show_leaf_name = True
ts.show_branch_support = True
t.render(NEWICK+".png", w=600, units="mm",tree_style=ts)
t.write(format=0, outfile=NEWICK+".newick")


# ゲノム情報の読み込み
info = pd.read_table(g_genome, sep='\t', index_col=0)
frame = pd.DataFrame(info)


# テーブルの並び替え
strain_list = t.get_leaf_names()
SORT = frame.reindex(strain_list)
SORT.to_csv(g_genome+'.sort.txt', sep='\t')



print("OUTPUT FILES:")
print(NEWICK+".newick")
print(NEWICK+".png")
print(g_genome+'.sort.txt')

print('--------------------------------------------------------------------------------------------------')
print(t)
print('--------------------------------------------------------------------------------------------------')
print(SORT)
